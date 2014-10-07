describe MSSQLTask do

	let(:course) { FactoryGirl.create(:course) }
	let(:task_list) { FactoryGirl.create(:task_list, course: course) }
	let(:variant) { FactoryGirl.create(:mssql_variant, course: course) }

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
end