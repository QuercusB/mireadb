class TaskVariant < ActiveRecord::Base
	validates_presence_of(:index)
	validates_presence_of(:course)
	
	belongs_to :course
end
