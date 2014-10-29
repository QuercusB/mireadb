#encoding: UTF-8

class AddSixthVariant < ActiveRecord::Migration
  def up
  	variant = MSSQLTaskVariant.create!({
  		index: 6,
  		course: Course.first,
  		host: 'mireadb.cg3urejuymam.eu-west-1.rds.amazonaws.com',
  		database: 'tyreshop',
  		username: 'quercus',
	  	password: 'mirea548',
	  	description: <<-DESC
	  		Вам предостоит работать с базой данных магазина по продаже шин.<br>
	  		В базе есть единственная (пока) таблица <code>Tyres</code> с полями:
	  		<ul>
	  			<li><code>ID</code> - идентификатор записи (int, суррогатный первичный ключ)</li>
	  			<li><code>Name</code> - название шины (nvarchar(255), обязательное)</li>
	  			<li><code>Manufacturer</code> - производитель шины (nvarchar(255), обязательно)</li>
	  			<li><code>Price</code> - цена шины (decimal(15,2), обязательное)</li>
	  			<li><code>Rating</code> - рейтинг шины (int от 0 до 10, необязательное)</li>
	  			<li><code>RatedBy</code> - количество людей указавших рейтинг шины (int, необязательное)</li>
	  			<li><code>Season</code> - сезонность шины (nvarchar(255), обязательное - либо 'winter', либо 'summer')</li>
	  			<li><code>Studded</code> - шипованная ли шина (bit, необязательное)</li>
	  		</ul>
	  	DESC
	  	})

  	task_list = Course.first.task_lists.first

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 0,
  		title: 'Получаем всю информацию из таблицы',
  		subject: 'Получите всю информацию о шинах.<br>Напишите SQL-запрос, который вернет все данные (все строки со всеми полями) из таблицы <code>Tyres</code>',
  		data: { answer: 'SELECT * FROM Tyres', order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 1,
  		title: 'Только нужные поля',
  		subject: 'Теперь нам интересны не все поля, а только идентификатор, название, цена и является ли она шипованной.<br>Из таблицы <code>Tyres</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>Price</code> и <code>Studded</code>',
  		data: { answer: 'SELECT ID, Name, Price, Studded FROM Tyres', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 2,
  		title: 'Переименовываем колонки',
  		subject: 'Оказалось, что в для приложения признак шипованности должен называться IsStudded - переименуйте колонку.<br>Из таблицы <code>Tyres</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>Price</code> и <code>IsStudded</code>, где <code>IsStudded</code> - это переименованное поле <code>Studded</code>',
  		data: { answer: 'SELECT ID, Name, Price, Studded as IsStudded FROM Tyres', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 3,
  		title: 'Вычисляемое поле', 
  		subject: 'Вычислите цену комплекта шин (4 штук) для каждой шины.<br>Из таблицы <code>Tyres</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>Price</code> и <code>PackPrice</code>, где поле <code>PackPrice = 4 * Price</code>',
  		data: { answer: 'SELECT ID, Name, Price, 4 * Price as PackPrice FROM Tyres', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 4,
  		title: 'Уникальный список',
  		subject: 'Шины каких производителей присутствуют в нашем магазине?<br>Напишите запрос возвращающий список различных (без повторений) значений поля <code>Manufacturer</code> из таблицы <code>Tyres</code><em>Для получения уникальных строк используйте ключевое слово <code>Distinct</code></em>',
  		data: { answer: 'SELECT DISTINCT Manufacturer FROM Tyres', order_key: 'Manufacturer', distinct: true }
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 5,
		title: 'Только нужные записи',
		subject: 'Зима на дворе. Какие у нас есть зимние шины?<br>Напишите запрос получающий только те строки таблицы <code>Tyres</code>, где <code>Season</code> равно \'winter\'',
		data: { answer: 'SELECT * FROM Tyres WHERE Season = \'winter\'', order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 6,
		title: 'Усложняем критерий отбора',
		subject: 'Тратить много на зимнюю резину не хочется (допустим, редко ездим или жаба душит). Отберем те, у которых цена менее 2000 и чтобы рейтинг не ниже 8.<br>Напишите запрос получающий только те строки таблицы <code>Tyres</code>, где <code>Season</code> равно \'winter\', <code>Price</code> меньше 2000, а <code>Rating</code> не меньше 8',
		data: { answer: 'SELECT * FROM Tyres WHERE Season = \'winter\' and Price < 2000 and Rating >= 8', follows: true,  order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 7,
		title: 'Работаем с NULL',
		subject: 'Шины противно стучат по асфальту. Какие из отобранных шин нешипованные?<br>Напишите запрос получающий только те строки таблицы <code>Tyres</code>, где <code>Season</code> равно \'winter\', <code>Price</code> менее 2000, <code>Rating</code> не меньше 8 и <code>Studded</code> не задано (равно <code>NULL</code>).',
		data: { answer: 'SELECT * FROM Tyres WHERE Season = \'winter\' and Price < 2000 and Rating >= 8 and Studded is null', follows: true, order_key: 'ID'}
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 8,
		title: 'Сортировка данных',
		subject: 'Пожалуй стоит посмотреть что есть хорошего из дешевых шин. Надо отсортировать шины по цене.<br>Напишите запрос получающий все строки таблицы <code>Tyres</code> отсортированые в порядке возрастания <code>Price</code>.',
		data: { answer: 'SELECT * FROM Tyres ORDER BY Price', order_key: 'Price', ordered: 1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 9,
		title: 'Ограничение количества данных',
		subject: 'Теперь нас интересует топ-лист наиболее дорогих шин.<br>Напишите запрос получающий первые 10 строк таблицы <code>Tyres</code>, отсортированной в порядке убывания поля <code>Price</code>.',
		data: { answer: 'SELECT TOP 10 * FROM Tyres ORDER BY Price DESC', follows:true, order_key: 'Price', ordered: -1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 10,
		title: 'Собираем статистику',
		subject: 'Что же за данные у нас в базе - сколько там шин, что за цены?<br>Напишите запрос получающий по таблице <code>Tyres</code> 1 строку с полями <code>Total</code> (общее количество записей), <code>MinPrice</code> (минимальное значение поля <code>Price</code>), <code>AvgPrice</code> (среднее значение поля <code>Price</code>), <code>MaxPrice</code> (максимальное значение поля <code>Price</code>)',
		data: { answer: 'SELECT COUNT(*) as Total, Min(Price) as MinPrice, Avg(Price) as AvgPrice, Max(Price) as MaxPrice from Tyres' }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 11,
		title: 'Статистика с группировкой',
		subject: 'Теперь нас интересует распределение цены относительно производителя.<br>Напишите запрос который сгруппирует данные таблицы <code>Tyres</code> по полю <code>Manufacturer</code> и вернет несколько строк с полями: <code>Manufacturer</code> (прозводитель шины), <code>N</code> (количество шин данного производителя) и <code>AvgPrice</code> (среднее значение поля <code>Price</code>)',
		data: { answer: 'SELECT Manufacturer, COUNT(*) as N, Avg(Price) as AvgPrice FROM Tyres GROUP BY Manufacturer', order_key: 'Socket'}
	})
  end

  def down
	variant = MSSQLTaskVariant.find_by_index(6)
	MSSQLTask.where(task_variant: variant).destroy_all
	variant.destroy
  end
end
