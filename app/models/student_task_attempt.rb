class StudentTaskAttempt < ActiveRecord::Base
	include DataContainer

	validates_presence_of :student
	validates_presence_of :task
	
	belongs_to :student
	belongs_to :task
end
