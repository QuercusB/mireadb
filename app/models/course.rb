class Course < ActiveRecord::Base
	validates_presence_of :code
	validates_presence_of :name
	
	has_many :task_lists
	has_many :task_variants
end
