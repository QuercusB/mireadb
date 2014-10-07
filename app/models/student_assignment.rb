class StudentAssignment < ActiveRecord::Base
	validates_presence_of :student
	validates_presence_of :task_variant

	belongs_to :student
	belongs_to :task_variant
end
