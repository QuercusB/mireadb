class TaskList < ActiveRecord::Base
	validates_presence_of :index
	validates_presence_of :name
	validates_presence_of :course
	
	belongs_to :course
	has_many :tasks

	def student_tasks(student)
		StudentTask.includes(:task).where(task_list: self, student: student)
	end
end
