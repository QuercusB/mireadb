describe MSSQLStudentTaskAttempt do
	let(:student) { FactoryGirl.create(:student) }
	let(:task) { FactoryGirl.create(:task) }

	it 'inherits from StudentTaskAttempt' do
		expect(MSSQLStudentTaskAttempt.superclass).to eq(StudentTaskAttempt)
	end

	it 'has query and result field' do
		attempt = MSSQLStudentTaskAttempt.new(student: student, task: task)
		attempt.query = 'SELECT * FROM Contacts'
		result = { columns: [ 'a', 'b'], missing_columns: ['c'], extra_columns: [], rows: [ [10, 5], [3, 5] ], missing_rows: [ [2, 'Hello']], extra_rows: [1] }
		attempt.result = result.to_json
		expect(attempt.save).to eq(true)
		attempt = StudentTaskAttempt.find(attempt.id)
		expect(attempt.query).to eq('SELECT * FROM Contacts')
		expect(JSON.parse(attempt.result).symbolize_keys).to eq(result)
	end
end