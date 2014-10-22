class TaskListsController < ApplicationController
	layout 'student'
	before_action :set_course
	before_action :set_task_list, except: :index

	def index
		if @course.task_lists.length == 1
			redirect_to course_task_list_path(@course, @course.task_lists.first)
		end
	end

	def show
		redirect_to course_task_list_tasks_path(@course, @task_list)
	end

	protected

	def set_course
		@course = Course.find(params[:course_id])
	end

	def set_task_list
		@task_list = @course.task_lists.find(params[:id])
	end
end
