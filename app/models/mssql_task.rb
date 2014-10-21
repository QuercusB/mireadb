#encoding: UTF-8

class MSSQLTask < Task
	data_field :answer
	data_field :order_key
	data_field :distinct
	data_field :ordered
	data_field :follows

	def solve(options = {})
		query = options[:query] || options["query"]
		raise ArgumentError.new('Query not specified') if query.blank?

		result = MSSQLStudentTaskAttempt.new(task: self, query: query)

		connection = task_variant.connect
		begin
			connection.begin_db_transaction
			query_result = connection.exec_query(options[:query])
			result.result = { columns: query_result.columns, rows: query_result.rows }
			answer_result = connection.exec_query(self.answer)
			result.done = check_query_result(result.result, answer_result)
			result.error_message = "Неверный результат" unless result.done?
			if result.done? && ordered
				result.done = check_result_ordered(result.result)
				result.error_message = "Данные не отсортированы по #{order_key}" unless result.done?
			end
		rescue ActiveRecord::StatementInvalid => e
			if e.original_exception.is_a? TinyTds::Error
				result.error_message = e.original_exception.message
			else
				result.error_message = e.message
			end
		ensure
			connection.rollback_db_transaction
		end
		return result
	end

	private 

	def check_query_result(query_result, answer_result)
		query_result[:extra_columns] = []
		query_result[:missing_columns] = []
		query_result[:extra_rows] = []
		query_result[:missing_rows] = []
		query_common_columns_indexes = {}
		query_result[:columns].each_index do |column_index|
			column = query_result[:columns][column_index]
			if answer_result.columns.any? { |x| x.casecmp(column) == 0 }
				query_common_columns_indexes[column.downcase] = column_index
			else
				query_result[:extra_columns] << column_index
			end
		end
		answer_common_columns_indexes = {}
		answer_result.columns.each_index do |column_index|
			column = answer_result.columns[column_index]
			if query_result[:columns].any? { |x| x.casecmp(column) == 0 }
				answer_common_columns_indexes[column.downcase] = column_index
			else
				query_result[:missing_columns] << column
			end
		end
		unless query_common_columns_indexes.blank? ||
			answer_common_columns_indexes.blank?
			query_projection = query_result[:rows].map { |row|
				query_common_columns_indexes.keys.sort.map { |column_name| row[query_common_columns_indexes[column_name]] }
			}
			answer_projection = answer_result.rows.map { |row|
				answer_common_columns_indexes.keys.sort.map { |column_name| row[answer_common_columns_indexes[column_name]] }
			}
			answer_uniq = answer_projection.clone
			query_projection.each_index do |row_index|
				if answer_uniq.include? (query_projection[row_index])
					answer_uniq.delete (query_projection[row_index])
				else
					query_result[:extra_rows] << row_index
				end 
			end
			answer_projection.each_index do |row_index|
				row = answer_result.rows[row_index]
				unless query_projection.include? (answer_projection[row_index])
					query_result[:missing_rows] << query_result[:columns].map { |x|
						if answer_common_columns_indexes.key? (x.downcase)
							row[answer_common_columns_indexes[x.downcase]]
						else
							"???"
						end
					}
				end
			end
		end
		return query_result[:extra_columns].blank? &&
			query_result[:extra_rows].blank? &&
			query_result[:missing_rows].blank? &&
			query_result[:missing_columns].blank?
	end

	def check_result_ordered(query_result)
		order_column = query_result[:columns].index(order_key)
		return true if query_result[:rows].empty?
		prev_value = query_result[:rows].first[order_column]
		query_result[:rows].each do |row|
			value = row[order_column]
			compare = 0
			if prev_value < value
				compare = 1
			end
			if prev_value > value
				compare = -1
			end
			return false if compare != 0 && compare != ordered
			prev_value = value
		end
		return true
	end
end