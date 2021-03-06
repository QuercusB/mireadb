#encoding: UTF-8

FactoryGirl.define do
	factory :task, class: MSSQLTask do
		sequence(:index)
		sequence(:subject) { |n| "Task subject #{n}" }
		sequence(:title) { |n| "Task #{n}" }
		task_list
		task_variant
	end

	factory :mssql_task, class: MSSQLTask do
		index 0
		title 'Выбираем все сразу'
    	subject 'Напишите SQL-оператор, возвращающий все данные (все строки и столбцы) из таблицы <code>Contacts</code>'
    	answer 'SELECT * FROM Contacts'
		task_list
		task_variant { FactoryGirl.create(:mssql_variant) }
	end
end
