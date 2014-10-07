class TaskVariant < ActiveRecord::Base
	include DataContainer

	validates_presence_of(:index)
	validates_presence_of(:course)
	
	belongs_to :course

	has_many :student_assignments
	has_many :students, through: :student_assignments
end
