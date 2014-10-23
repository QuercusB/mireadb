#encoding: UTF-8

class AddSecondVariant < ActiveRecord::Migration
  def up
  	variant = MSSQLTaskVariant.create!({
  		index: 2,
  		course: Course.first,
  		host: 'mireadb.cg3urejuymam.eu-west-1.rds.amazonaws.com',
  		database: 'abiturients',
  		username: 'quercus',
	  	password: 'mirea548',
	 	description: <<-DESC
	  		Вам предостоит работать с базой, содержащей данные о студентах.<br>
	  		В базе есть единственная таблица <code>People</code> с полями:
	  		<ul>
	  			<li><code>ID</code> - идентификатор записи (int, суррогатный первичный ключ)</li>
	  			<li><code>FirstName</code> - имя студента (nvarchar(255), обязательное)</li>
	  			<li><code>LastName</code> - фамилия студента (nvarchar(255), обязательное)</li>
	  			<li><code>Age</code> - возраст студента (int, обязательное)</li>
	  			<li><code>IsBudget</code> - находится ли студент на бюджетном отделении (bit, необязательное)</li>
	  		</ul>
	  	DESC
	})

  	task_list = Course.first.task_lists.first

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 0,
  		title: 'Получаем всю информацию из таблицы',
  		subject: 'Получите всю информацию по студентам.<br>Напишите SQL-запрос, который вернет все данные (все строки со всеми полями) из таблицы <code>People</code>',
  		data: { answer: 'SELECT * FROM People', order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 1,
  		title: 'Только нужные поля',
  		subject: 'Теперь нам интересны не все поля, а только <code>ID</code>, <code>FirstName</code>, <code>LastName</code>.<br>Из таблицы <code>People</code> получите данные по всем строкам с полями: <code>ID</code>, <code>FirstName</code> и <code>LastName</code>',
  		data: { answer: 'SELECT ID, FirstName, LastName FROM People', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 2,
  		title: 'Переименовываем колонки',
  		subject: 'Оказалось, что мы неправильно назвали колонки в базе данных, и для приложения нужны другие имена полей.<br>Из таблицы <code>People</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code> и <code>Surname</code>, где поле <code>Name</code> - это переименованное <code>FirstName</code>, а <code>Surname</code> - переименованное <code>LastName</code>',
  		data: { answer: 'SELECT ID, FirstName as Name, LastName as Surname FROM People', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 3,
  		title: 'Вычисляемое поле', 
  		subject: 'Для приложения также требуется поле <code>Initials</code> с инициалами студента (первая буква имени + первая буква фамилии).<br>Из таблицы <code>People</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>Surname</code> и <code>Initials</code>, где <code>Name</code> - <code>FirstName</code>, <code>Surname</code> - <code>LastName</code>, а <code>Initials</code> - поле содержащее инициалы студента.<em>Для получения первой буквы имени используйте функцию SUBSTRING(&lt;поле&gt;,1,1)</em>',
  		data: { answer: 'SELECT ID, FirstName as Name, LastName as Surname, SUBSTRING(FirstName,1,1) + SUBSTRING(LastName,1,1) as Initials FROM People', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 4,
  		title: 'Список фамилий',
  		subject: 'Не очень понятно зачем, но потребовался список фамилий студентов, причем без повторений.<br>Напишите запрос для выборки всех различных фамилий (поле <code>LastName</code>) из таблицы <code>People</code>.<em>Для получения уникальных строк используйте ключевое слово <code>Distinct</code></em>',
  		data: { answer: 'SELECT DISTINCT LastName FROM People', order_key: 'LastName', distinct: true }
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 5,
		title: 'Только нужные записи',
		subject: 'В институт поступают не только после окончания школы - получите список тех, кому 18 или больше лет.<br>Напишите запрос получающий только те строки таблицы <code>People</code>, где <code>Age</code> больше или равно 18',
		data: { answer: 'SELECT * FROM People WHERE Age >= 18', order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 6,
		title: 'Усложняем критерий отбора',
		subject: 'Каким-то образом абитуриенты старше 18 попали на бюджет - получите их.<br>Напишите запрос получающий только те строки таблицы <code>People</code>, где <code>Age</code> больше или равно 18 и поле <code>IsBudget</code> равно 1',
		data: { answer: 'SELECT * FROM People WHERE Age >= 18 and IsBudget = 1', follows: true,  order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 7,
		title: 'Работаем с NULL',
		subject: 'На этот раз нас интересует список студентов младше 18 лет, но не попавших на бюджет.<br>Напишите запрос получающий только те строки таблицы <code>People</code>, где <code>Age</code> менее 18 и поле <code>IsBudget</code> не равно 1.<em>Обратите внимание в некоторых строках поле <code>IsBudget</code> незаполнено (равно <code>NULL</code>).',
		data: { answer: 'SELECT * FROM People WHERE Age < 18 and ISNULL(IsBudget, 0) = 0', follows: true, order_key: 'ID'}
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 8,
		title: 'Сортировка данных',
		subject: 'В приложении мы решили поддерживать сортировку по различным полям (для начала по возрасту).<br>Напишите запрос получающий все строки таблицы <code>People</code> отсортированые в порядке возрастания <code>Age</code>.',
		data: { answer: 'SELECT * FROM People ORDER BY Age', order_key: 'Age', ordered: 1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 9,
		title: 'Ограничение количества данных',
		subject: 'Продолжаем работать с сортировкой, теперь нужны записи отсортированные по убыванию по возрасту, при этом только первые 10.<br>Напишите запрос получающий первые 10 строк таблицы <code>People</code>, отсортированной в порядке убывания <code>Age</code>.',
		data: { answer: 'SELECT TOP 10 * FROM People ORDER BY Age DESC', follows: true, order_key: 'Age', ordered: -1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 10,
		title: 'Собираем статистику',
		subject: 'Соберите статистику по студентам: их количество, минимальный возраст, максимальный возраст, количество бюджетников.<br>Напишите запрос получающий по таблице <code>People</code> 1 строку с полями <code>Total</code> (общее количество записей), <code>MinAge</code> (минимальное значение поля <code>Age</code>), <code>MaxAge</code> (максимальное значение поля <code>Age</code>), <code>Budget</code> (количество записей с <code>IsBudget</code> равным 1).<em>В колонке <code>IsBudget</code> стоит либо 1, либо 0, поэтому чтобы получить количество бюджетников надо просто просуммировать эту колонку, однако, суммировать тип <code>bit</code> в MSSQL нельзя - надо сначала привести ее к <code>int</code> с помощью <code>CAST(&lt;поле&gt; as int)</code>',
		data: { answer: 'SELECT COUNT(*) as Total, MIN(Age) as MinAge, MAX(Age) as MaxAge, SUM(CAST(IsBudget as int)) as Budget FROM People' }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 11,
		title: 'Статистика с группировкой',
		subject: 'Теперь нас интересует распределение студентов по возрастам.<br>Напишите запрос который сгруппирует данные таблицы <code>People</code> и вернет несколько строк с полями: <code>Age</code> (возраст), <code>N</code> (количество студентов с таким возрастом)',
		data: { answer: 'SELECT Age, COUNT(*) as N FROM People GROUP BY Age ORDER BY Age', order_key: 'Age'}
	})
  end

  def down
	variant = MSSQLTaskVariant.find_by_index(2)
	MSSQLTask.where(task_variant: variant).destroy_all
	variant.destroy
  end
end

