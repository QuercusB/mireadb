class CoursesController < ApplicationController
	layout 'student'
	before_action :authenticate_student!
	before_action :set_course, except: :index

	def index
		@courses = current_student.courses
		if @courses.length == 1
			redirect_to course_path(@courses.first)
		elsif @courses.length == 0
			redirect_to course_path(Course.first)
		end
	end

	def show
		redirect_to course_task_lists_path(@course)
	end

	protected

	def set_course
		@course = Course.find(params[:id])
	end

end
