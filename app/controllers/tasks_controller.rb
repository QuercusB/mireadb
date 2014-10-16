#encoding: UTF-8

class TasksController < ApplicationController
	layout 'student'
	before_action :set_course_and_list
	before_action :set_task, except: :index
	respond_to :html, :json

	def index
	end

	def show
		@attempt = StudentTaskAttempt.where(student: current_student, task: @task, done: true).first ||
			StudentTaskAttempt.where(student: current_student, task: @task).last
	end

	def attempt
		begin
			render json: StudentTaskAttempt.make_attempt(current_student, @task, params)
		rescue => e
			render json: { done: false, error_message: "Ошибка запроса: #{e.message}"}
		end
	end

	protected

	def set_course_and_list
		@course = Course.find(params[:course_id])
		@task_list = @course.task_lists.find(params[:task_list_id])
	end

	def set_task
		@task = @task_list.student_tasks(current_student).find_by_task_id(params[:id]).try(:task)
	end
end
