#encoding: UTF-8

class CreateFirstTaskListAndTask < ActiveRecord::Migration
  def up
  	course = Course.first
  	list = TaskList.create!(course: course, name: 'Простая выборка данных')
  	variant = TaskVariant.first
    task = MSSQLTask.new(task_list: list, task_variant: variant)
    task.title = 'Выбираем все сразу'
    task.subject = 'Напишите SQL-оператор, возвращающий все данные (все строки и столбцы) из таблицы <code>Contacts</code>'
    task.answer = 'SELECT * FROM Contacts'
    task.save!
  end

  def down
  end
end
