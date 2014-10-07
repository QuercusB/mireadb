require 'rails_helper'

RSpec.describe StudentTaskAttempt, :type => :model do
	it { should validate_presence_of(:student) }
	it { should validate_presence_of(:task) }

	let(:student) { FactoryGirl.create(:student) }
	let(:task) { FactoryGirl.create(:task) }

	it 'is polymorphic' do
		attempt = DummyStudentTaskAttempt.create!(student: student, task: task)
		expect(StudentTaskAttempt.find(attempt.id).class).to eq(DummyStudentTaskAttempt)
	end

	it 'can have data fields stored in data' do
		attempt = DummyStudentTaskAttempt.new(student: student, task: task)
		attempt.sql = 'SEELECT * FROM Contacts'
		attempt.result = '<ERROR>Invalid SQL-command</ERROR>'
		expect(attempt.save).to eq(true)
		attempt = StudentTaskAttempt.find(attempt.id);
		expect(attempt.sql).to eq('SEELECT * FROM Contacts')
		expect(attempt.result).to eq('<ERROR>Invalid SQL-command</ERROR>')
	end
end

class DummyStudentTaskAttempt < StudentTaskAttempt
	data_field :sql
	data_field :result
end
