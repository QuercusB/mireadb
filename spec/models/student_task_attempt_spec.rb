require 'rails_helper'

RSpec.describe StudentTaskAttempt, :type => :model do
	it { should validate_presence_of(:student) }
	it { should validate_presence_of(:task) }

	let(:student) { FactoryGirl.create(:student) }
	let(:task) { FactoryGirl.create(:task) }

	context 'by default' do
		subject { StudentTaskAttempt.new() }

		its(:done?) { should eq(false) }
		its(:error_message) { should be_nil } 
	end

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

	context 'making attempt' do
		it 'should have class method make_attempt' do
			expect(StudentTaskAttempt).to respond_to(:make_attempt)
		end

		it 'when making attempt we call Task.solve with given arguments and expect to receive subclass of attempt to assign student and save' do
			sample_args = Object.new
			solve_result = Object.new
			expect(task).to receive(:solve).with(sample_args).and_return(solve_result)
			expect(solve_result).to receive(:student=).with(student)
			expect(solve_result).to receive(:save!)
			expect(StudentTaskAttempt.make_attempt(student, task, sample_args)).to eq(solve_result)
		end
	end
end

class DummyStudentTaskAttempt < StudentTaskAttempt
	data_field :sql
	data_field :result
end
