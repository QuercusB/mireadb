class StudentTask < ActiveRecord::Base
	belongs_to :task_list
	belongs_to :student
	belongs_to :task

	def done?
		self.done == 't'
	end

end
