class FixingStudentTaskViewDoneColumn < ActiveRecord::Migration
  def up
  	begin
	  self.connection.execute "DROP VIEW student_tasks"
	rescue
	end
	  
      self.connection.execute <<-QUERY
      	CREATE VIEW student_tasks AS    
			SELECT
				task_list.id as task_list_id,
				student_assignment.student_id as student_id,
				task.id as task_id,
				MAX(attempt.done) as done
			FROM
				task_lists task_list
				JOIN courses course
					ON course.id = task_list.course_id
				JOIN task_variants variant
					ON variant.course_id = course.id
				JOIN student_assignments student_assignment
					ON student_assignment.task_variant_id = variant.id
				JOIN tasks task
					ON task.task_list_id = task_list.id AND task.task_variant_id = variant.id
				LEFT JOIN student_task_attempts attempt
				    ON attempt.task_id = task.id and attempt.student_id = student_assignment.student_id
			GROUP BY task_list.id, student_assignment.student_id, task.id
         QUERY
  end

  def down
  	self.connection.execute "DROP VIEW student_tasks"
  end
end
