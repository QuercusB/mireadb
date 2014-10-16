require 'rails_helper'

RSpec.describe Student, :type => :model do
	it { should validate_presence_of(:first_name) }
	it { should validate_presence_of(:last_name) }
	it { should validate_presence_of(:login) }
	it { should validate_uniqueness_of(:login) }

	context 'display name' do
		it 'is built from first name and last name' do
			student = Student.new(first_name: 'Pavel', last_name: 'Borisov')
			expect(student.display_name).to eq("Borisov Pavel")
		end

		it 'contains only last name if first name is blank' do
			student = Student.new(first_name: ' ', last_name: 'Borisov')
			expect(student.display_name).to eq("Borisov")
		end

		it 'contains only first name if last name is blank' do
			student = Student.new(first_name: 'Pavel', last_name: ' ')
			expect(student.display_name).to eq("Pavel")
		end
	end
end
