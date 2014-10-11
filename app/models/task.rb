class Task < ActiveRecord::Base
	include DataContainer

	validates_presence_of :index
	validates_presence_of :subject
	validates_presence_of :type
	validates_presence_of :task_list
	validates_presence_of :task_variant
	validates_presence_of :title

	belongs_to :task_list
	belongs_to :task_variant
end
