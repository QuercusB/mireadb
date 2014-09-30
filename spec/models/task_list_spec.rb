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
end
