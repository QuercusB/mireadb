#encoding: UTF-8

describe MSSQLTask do

	let(:course) { FactoryGirl.create(:course) }
	let(:task_list) { FactoryGirl.create(:task_list, course: course) }
	let(:variant) { FactoryGirl.create(:mssql_variant, course: course) }
	let(:mssql_task) { FactoryGirl.create(:mssql_task, task_list: task_list, task_variant: variant )}

	it 'inherits from task' do
		expect(MSSQLTask.superclass).to eq(Task)
	end

	it 'has answer field' do
		task = MSSQLTask.new(task_list: task_list, task_variant: variant, index: 0, subject: 'Testing', title: 'Test')
		task.answer = 'SELECT * FROM Contacts'
		expect(task.save).to eq(true)
		task = Task.find(task.id)
		expect(task.answer).to eq('SELECT * FROM Contacts')
	end

	context 'solve operation' do

		it 'creates connection and invokes query from args on it' do
			query = 'SELECT * FROM Contacts2'
			connection = double
			expect(variant).to receive(:connect).and_return(connection)
			expect(connection).to receive(:begin_db_transaction)
			expect(connection).to receive(:exec_query).with(query).and_raise(ActiveRecord::StatementInvalid.new("", TinyTds::Error.new("Table Contacts2 doesn't exist")))
			expect(connection).to receive(:rollback_db_transaction)
			mssql_task.solve({query: query})
		end

		it 'raises an exception if query is not specified' do
			expect(variant).not_to receive(:connect)
			expect { mssql_task.solve() }.to raise_error(ArgumentError)
		end

		it 'raises an exception if query is empty one' do
			expect(variant).not_to receive(:connect)
			expect { mssql_task.solve({query:''}) }.to raise_error(ArgumentError)
		end

		context 'return value when it fails due to invalid request failure' do

			let(:query) { "SELECT * FROM Contacts2" }
			let(:message) { "Table Contacts2 doesn't exist" }

			subject {
				connection = double
				allow(connection).to receive(:begin_db_transaction)
				allow(variant).to receive(:connect).and_return(connection)
				allow(connection).to receive(:exec_query).with(query).and_raise(ActiveRecord::StatementInvalid.new("", TinyTds::Error.new(message)))
				allow(connection).to receive(:rollback_db_transaction)
				mssql_task.solve({query: query})
			}

			it { should_not be_nil }
			its(:class) { should eq(MSSQLStudentTaskAttempt) }
			it { should_not be_done }
			its(:error_message) { should eq(message) }
			its(:task) { should eq(mssql_task) }
			its(:query) { should eq(query) }
			its(:result) { should be_nil }
		end

		it 'if test query succeeds invokes answer query' do
			query = 'SELECT * FROM Contacts2'
			connection = double
			expect(variant).to receive(:connect).and_return(connection)
			expect(connection).to receive(:begin_db_transaction)
			expect(connection).to receive(:exec_query).once.ordered.with(query).and_return(double('ActiveRecord::Result', columns: ["ID"], rows: []))
			expect(connection).to receive(:exec_query).once.ordered.with(mssql_task.answer).and_return(double('ActiveRecord::Result', columns: ["ID"], rows: []))
			expect(connection).to receive(:rollback_db_transaction)
			mssql_task.solve({query: query})
		end

		context 'return value when request succeeds but it''s not an answer' do
			let(:query) { "SELECT ID, LastName as Last FROM Contacts WHERE ID < 3" }
			let(:result) { double('ActiveRecord::Result', 
				columns: ["ID", "Last"], 
				rows: [[1, "Борисов"], [2, "Плешанов"]]) }
			let(:answer_result) { double('ActiveRecord::Result', 
				columns: ["FirstName", "Id", "LastName"], 
				rows: [["Павел", 1, "Борисов"], ["Сергей", 3, "Плешанов"]]) }

			subject {
				connection = double
				allow(connection).to receive(:begin_db_transaction)
				allow(variant).to receive(:connect).and_return(connection)
				allow(connection).to receive(:exec_query).once.ordered.with(query).and_return(result)
				allow(connection).to receive(:exec_query).once.ordered.with(mssql_task.answer).and_return(answer_result)
				allow(connection).to receive(:rollback_db_transaction)
				mssql_task.solve({query: query})
			}

			it { should_not be_nil }
			its(:class) { should eq(MSSQLStudentTaskAttempt) }
			it { should_not be_done }
			its(:error_message) { should be_blank }
			its(:task) { should eq(mssql_task) }
			its(:query) { should eq(query) }
			its(:result) { should == { 
				columns: ["ID", "Last"], 
				rows: [[1, "Борисов"], [2, "Плешанов"]],
				extra_columns: ["Last"],
				missing_columns: ["FirstName", "LastName"],
				extra_rows: [1],
				missing_rows: [[3, "???"]] } }
		end
	end
end