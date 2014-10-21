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
		if @attempt.nil? && @task.follows
			prev_task = @task.task_list.tasks.where(task_variant: @task.task_variant, index: @task.index - 1).first
			if prev_task.nil?
				@prev_task_attempt = nil
			else
				@prev_task_attempt = StudentTaskAttempt.where(student: current_student, task: prev_task, done: true).first
			end
		else
			@prev_task_attempt = nil
		end
		@next_task = @task.task_list.tasks.where(task_variant: @task.task_variant, index: @task.index + 1).first
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
