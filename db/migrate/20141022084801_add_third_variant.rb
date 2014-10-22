#encoding: UTF-8

class AddThirdVariant < ActiveRecord::Migration
  def up
  	variant = MSSQLTaskVariant.create!({
  		index: 3,
  		course: Course.first,
  		host: 'mireadb.cg3urejuymam.eu-west-1.rds.amazonaws.com',
  		database: 'mcdonalds',
  		username: 'quercus',
	  	password: 'mirea548',
	  	description: <<-DESC
	  		Вам предостоит работать с базой, содержащей меню ресторанов McDonalds.<br>
	  		В базе есть единственная таблица <code>Menu</code> с полями:
	  		<ul>
	  			<li><code>ID</code> - идентификатор записи (int, суррогатный первичный ключ)</li>
	  			<li><code>Name</code> - название блюда (nvarchar(255), обязательное)</li>
	  			<li><code>CCal</code> - количество килокалорий в блюде (float, необязательное)</li>
	  			<li><code>Protein</code> - количество белка в блюде (float, необязательное)</li>
	  			<li><code>Fat</code> - количество жира в блюде (float, необязательное)</li>
	  			<li><code>Carbohydrates</code> - количество углеводов в блюде (float, необязательное)</li>
	  			<li><code>Sodium</code> - количество соли в блюде (float, необязательное)</li>
	  		</ul>
	  	DESC
	  	})

  	task_list = Course.first.task_lists.first

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 0,
  		title: 'Получаем всю информацию из таблицы',
  		subject: 'Получите всю меню.<br>Напишите SQL-запрос, который вернет все данные (все строки со всеми полями) из таблицы <code>Menu</code>',
  		data: { answer: 'SELECT * FROM Menu', order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 1,
  		title: 'Только нужные поля',
  		subject: 'Теперь нам интересны не все поля, а только идентификатор, название и количество калорий.<br>Из таблицы <code>Menu</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code> и <code>CCal</code>',
  		data: { answer: 'SELECT ID, Name, CCal FROM Menu', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 2,
  		title: 'Переименовываем колонки',
  		subject: 'Оказалось, что мы неправильно назвали колонки в базе данных, и для приложения нужны другие имена полей.<br>Из таблицы <code>Menu</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code> и <code>Calories</code>, где поле а <code>Calories</code> - переименованное поле <code>CCal</code>',
  		data: { answer: 'SELECT ID, Name, CCal as Calories FROM Menu', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 3,
  		title: 'Вычисляемое поле', 
  		subject: 'В 1г. белка содержится 4 килокалорий, в 1г. жира - 9 ККал, в 1г. углеводов - 4 ККал. Надо выяснить насколько заявленное кол-во килокалорий расходится со значением, вычисленным по кол-ву белков, жиров и углеводов.<br>Из таблицы <code>Menu</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>Calories</code> и <code>MysticCalories</code>, где поле <code>Calories</code> это переименованное <code>CCal</code>, а <code>MysticCalories</code> - вычисляемое поле по формуле <code>CCal - (4 * Protein + 9 * Fat + 4 * Carbohydrates)</code>',
  		data: { answer: 'SELECT ID, Name, CCal as Calories, CCal - (Protein * 4 + Fat * 9 + Carbohydrates * 4) as MysticCalories FROM Menu', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 4,
  		title: 'Уникальный список',
  		subject: 'На этот раз нас интересует как солят в McDonalds.<br>Напишите запрос возвращающий список различных (без повторений) значений поля <code>Sodium</code> из таблицы <code>Menu</code><em>Для получения уникальных строк используйте ключевое слово <code>Distinct</code></em>',
  		data: { answer: 'SELECT DISTINCT Sodium FROM Menu', order_key: 'Sodium', distinct: true }
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 5,
		title: 'Только нужные записи',
		subject: 'Кто-то нам рекомендовал потреблять поменьше калорий. Что из меню МсDonalds содержит менее 100 килокалорий?<br>Напишите запрос получающий только те строки таблицы <code>Menu</code>, где <code>CCal</code> менее 100',
		data: { answer: 'SELECT * FROM Menu WHERE CCal < 100', order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 6,
		title: 'Усложняем критерий отбора',
		subject: 'На первый взгляд, все в McDonalds что содержит менее 100 килокалорий не содержит и соли. Есть ли что-то менее 200 килокалорий, но соленое?<br>Напишите запрос получающий только те строки таблицы <code>Menu</code>, где <code>CCal</code> менее 100, а <code>Sodium</code> больше 0',
		data: { answer: 'SELECT * FROM Menu WHERE CCal < 100 and Sodium > 0', follows: true,  order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 7,
		title: 'Работаем с NULL',
		subject: 'На этот раз нас интересует список блюд, содержащих не менее 100 килокалорий, но не содержащих соли.<br>Напишите запрос получающий только те строки таблицы <code>Menu</code>, где <code>CCal</code> больше или равно 100 и поле <code>Sodium</code> равно 0 или не задано (равно <code>NULL</code>).',
		data: { answer: 'SELECT * FROM Menu WHERE CCal >= 100 and ISNULL(Sodium, 0) = 0', follows: true, order_key: 'ID'}
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 8,
		title: 'Сортировка данных',
		subject: 'В приложении мы решили поддерживать сортировку по различным полям (для начала по килокалориям).<br>Напишите запрос получающий все строки таблицы <code>Menu</code> отсортированые в порядке возрастания <code>CCal</code>.',
		data: { answer: 'SELECT * FROM Menu ORDER BY CCal', order_key: 'CCal', ordered: 1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 9,
		title: 'Ограничение количества данных',
		subject: 'Теперь нас интересует топ-лист наиболее калорийных блюд.<br>Напишите запрос получающий первые 10 строк таблицы <code>Menu</code>, отсортированной в порядке убывания <code>CCal</code>.',
		data: { answer: 'SELECT TOP 10 * FROM Menu ORDER BY CCal DESC', follows: true, order_key: 'CCal', ordered: -1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 10,
		title: 'Собираем статистику',
		subject: 'Мы решили доказать что продукты в McDonalds полезны. Поэтому надо собрать статистику: общее количество продуктов, средние калорийность, кол-во протеинов и жиров.<br>Напишите запрос получающий по таблице <code>Menu</code> 1 строку с полями <code>Total</code> (общее количество продуктов), <code>AvgCCal</code> (среднее значение поля <code>CCal</code>), <code>AvgProtein</code> (среднее значение поля <code>Protein</code>), <code>AvgFat</code> (среднее значение поля <code>Fat</code>)',
		data: { answer: 'SELECT COUNT(*) as Total, Avg(CCal) as AvgCCal, Avg(Protein) as AvgProtein, Avg(Fat) as AvgFat from Menu' }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 11,
		title: 'Статистика с группировкой',
		subject: 'Теперь нас интересует распределение калорийности и количества блюд относительно содержащейся в нем соли.<br>Напишите запрос который сгруппирует данные таблицы <code>Menu</code> и вернет несколько строк с полями: <code>Sodium</code> (количество соли), <code>N</code> (количество записей с таким значением соли), <code>AvgCCal</code> (среднее значение поля калорийность для заданного значения соли)<em>Значениям <code>NULL</code> и <code>0</code> должны соответствовать разные строки</em>',
		data: { answer: 'SELECT Sodium, COUNT(*) as N, Avg(CCal) as AvgCCal FROM Menu GROUP BY Sodium', follows: true, order_key: 'Age'}
	})
  end

  def down
	variant = MSSQLTaskVariant.find_by_index(3)
	MSSQLTask.where(task_variant: variant).destroy_all
	variant.destroy
  end
end
