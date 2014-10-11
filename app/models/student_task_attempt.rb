class StudentTaskAttempt < ActiveRecord::Base
	include DataContainer

	validates_presence_of :student
	validates_presence_of :task
	
	belongs_to :student
	belongs_to :task

	def self.make_attempt(student, task, args = {})
		result = task.solve(args)
		result.student = student
		result.save!
		result
	end
end
