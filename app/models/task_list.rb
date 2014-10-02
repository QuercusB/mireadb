class TaskList < ActiveRecord::Base
	validates_presence_of :index
	validates_presence_of :name
	validates_presence_of :course
	
	belongs_to :course
	has_many :tasks
end
