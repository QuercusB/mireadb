require 'rails_helper'

RSpec.describe StudentAssignment, :type => :model do
	it { should validate_presence_of(:student) }
	it { should validate_presence_of(:task_variant) }

	let(:course1) { FactoryGirl.create(:course) }
	let(:course2) { FactoryGirl.create(:course) }
	let(:variant1) { FactoryGirl.create(:task_variant, course: course1) }
	let(:variant2) { FactoryGirl.create(:task_variant, course: course2) }
	let(:variant3) { FactoryGirl.create(:task_variant, course: course1) }
	let(:student1) { FactoryGirl.create(:student) }
	let(:student2) { FactoryGirl.create(:student) }

	it 'allows student to sign in multiple courses' do
		StudentAssignment.create!(student: student1, task_variant: variant1)
		StudentAssignment.create!(student: student1, task_variant: variant2)
		expect(student1.task_variants).to include(variant1)
		expect(student1.task_variants).to include(variant2)
		expect(student1.courses).to include(course1)
		expect(student1.courses).to include(course2)
	end

	it 'allowes multiple students to share same variant' do
		StudentAssignment.create!(student: student1, task_variant: variant1)
		StudentAssignment.create!(student: student2, task_variant: variant1)
		expect(variant1.students).to include(student1)
		expect(variant1.students).to include(student2)
		expect(course1.students).to include(student1)
		expect(course1.students).to include(student2)
	end

	it 'allows multiple students to share same course but have different variants' do
		StudentAssignment.create!(student: student1, task_variant: variant1)
		StudentAssignment.create!(student: student2, task_variant: variant3)
		expect(variant1.students).to include(student1)
		expect(variant3.students).to include(student2)
		expect(course1.students).to include(student1)
		expect(course1.students).to include(student2)
	end
end
