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

	it 'has type column which provides polymorphic task variants' do
		variant = DummyTaskVariant.new(index: 1, course: course)
		variant.save!
		reloadVariant = TaskVariant.find(variant.id)
		expect(reloadVariant.class).to eq(DummyTaskVariant)
	end
	
	it 'subtypes can store their data in ''data'' column' do
		variant = DummyTaskVariant.new(index:1, course: course)
		variant.connection_string = "Server:123"
		variant.save!
		variant = TaskVariant.find(variant.id)
		expect(variant.connection_string).to eq("Server:123")
	end	
end

class DummyTaskVariant < TaskVariant
	data_field :connection_string
end
