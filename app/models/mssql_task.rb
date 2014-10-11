class MSSQLTask < Task
	data_field :answer

	def solve(options = {})
		query = options[:query]
		raise ArgumentError.new('Query not specified') if query.blank?

		result = MSSQLStudentTaskAttempt.new(task: self, query: query)

		connection = task_variant.connect
		begin
			connection.begin_db_transaction
			query_result = connection.exec_query(options[:query])
			result.result = { columns: query_result.columns, rows: query_result.rows }
			answer_result = connection.exec_query(self.answer)
			result.done = check_query_result(result.result, answer_result)
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
				query_result[:extra_columns] << column
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
			query_projection.each_index do |row_index|
				query_result[:extra_rows] << row_index unless answer_projection.include? (query_projection[row_index])
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
end