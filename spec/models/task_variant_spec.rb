require 'rails_helper'

RSpec.describe TaskVariant, :type => :model do
	it { should validate_presence_of(:index) }
	it { should validate_presence_of(:course) }
	
	let(:course) { FactoryGirl.create(:course) }
	
	it 'belongs to course, which has many task variants' do
		variant1 = FactoryGirl.create(:task_variant, course: course)
		variant2 = FactoryGirl.create(:task_variant, course: course)
		expect(variant1.course).to eq(course)
		expect(variant2.course).to eq(course)
		expect(course.task_variants).to include(variant1)
		expect(course.task_variants).to include(variant2)
	end
end
