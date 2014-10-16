class Student < ActiveRecord::Base
	validates_presence_of :first_name
	validates_presence_of :last_name
	validates_presence_of :login
	validates_uniqueness_of :login

	has_many :student_assignments
	has_many :task_variants, through: :student_assignments
	has_many :courses, through: :task_variants

	def display_name
		((self.last_name || "").strip + ' ' + (self.first_name || "").strip).strip
	end
end
