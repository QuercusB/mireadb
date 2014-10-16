require 'rails_helper'

RSpec.describe TaskList, :type => :model do
	it { should validate_presence_of(:index) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:course) }
	
	let(:course) { FactoryGirl.create(:course) }
	
	it 'course can have many task-lists' do
		list1 = FactoryGirl.create(:task_list, course: course)
		list2 = FactoryGirl.create(:task_list, course: course)
		expect(list1.course).to eq(course)
		expect(list2.course).to eq(course)
		expect(course.task_lists).to include(list1)
		expect(course.task_lists).to include(list2)
	end

	it 'returns list of tasks filtered for student' do
		variant1 = FactoryGirl.create(:task_variant, course: course)
		variant2 = FactoryGirl.create(:task_variant, course: course)
		student1 = FactoryGirl.create(:student)
		student2 = FactoryGirl.create(:student)
		StudentAssignment.create!(student: student1, task_variant: variant1)
		StudentAssignment.create!(student: student2, task_variant: variant2)
		task_list = FactoryGirl.create(:task_list, course: course)
		task1 = FactoryGirl.create(:task, task_list: task_list, task_variant: variant1)
		task2 = FactoryGirl.create(:task, task_list: task_list, task_variant: variant2)
		puts task_list.student_tasks(student1).map { |x| x.task }.inspect
		expect(task_list.student_tasks(student1).map { |x| x.task }).to match_array([task1])
		expect(task_list.student_tasks(student2).map { |x| x.task }).to match_array([task2])
	end
end
