class CoursesController < ApplicationController
	layout 'student'
	before_action :set_course, except: :index

	def index
		@courses = current_student.courses
	end

	def show
		redirect_to course_task_lists_path(@course)
	end

	protected

	def set_course
		@course = Course.find(params[:id])
	end

end
