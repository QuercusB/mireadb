#encoding: UTF-8

class CreateFirstStudent < ActiveRecord::Migration
  def up
    student = Student.create!(login: 'e.morozov', first_name: 'Евгений', last_name: 'Морозов')
    StudentAssignment.create!(student: student, task_variant: TaskVariant.first)
  end

  def down
  end
end
