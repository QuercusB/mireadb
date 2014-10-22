#encoding: UTF-8

class AddFourthVariant < ActiveRecord::Migration
  def up
  	variant = MSSQLTaskVariant.create!({
  		index: 4,
  		course: Course.first,
  		host: 'mireadb.cg3urejuymam.eu-west-1.rds.amazonaws.com',
  		database: 'processors',
  		username: 'quercus',
	  	password: 'mirea548',
	  	description: <<-DESC
	  		Вам предостоит работать с базой, содержащей данные о процессорах.<br>
	  		В базе есть единственная таблица <code>Chips</code> с полями:
	  		<ul>
	  			<li><code>ID</code> - идентификатор записи (int, суррогатный первичный ключ)</li>
	  			<li><code>Name</code> - название процессора (nvarchar(255), обязательное)</li>
	  			<li><code>Price</code> - цена процессора (decimal(15,2), обязательное)</li>
	  			<li><code>Socket</code> - гнездо процессора (nvarchar(255), обязательное)</li>
	  			<li><code>Kernel</code> - ядро процессора (nvarchar(255), обязательное)</li>
	  			<li><code>L1Cache</code> - размер кэша L1 (int, обязательное)</li>
	  			<li><code>L2Cache</code> - размер кэша L2 (int, обязательное)</li>
	  			<li><code>L3Cache</code> - размер кэша L3 (int, обязательное)</li>
	  			<li><code>Graphics</code> - название графического ядра (nvarchar(255), необязательное)</li>
	  		</ul>
	  	DESC
	  	})

  	task_list = Course.first.task_lists.first

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 0,
  		title: 'Получаем всю информацию из таблицы',
  		subject: 'Получите всю информацию о процессорах.<br>Напишите SQL-запрос, который вернет все данные (все строки со всеми полями) из таблицы <code>Chips</code>',
  		data: { answer: 'SELECT * FROM Chips', order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 1,
  		title: 'Только нужные поля',
  		subject: 'Теперь нам интересны не все поля, а только идентификатор, название и размеры кэшей.<br>Из таблицы <code>Chips</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>L1Cache</code>, <code>L2Cache</code> и <code>L3Cache</code>',
  		data: { answer: 'SELECT ID, Name, L1Cache, L2Cache, L3Cache FROM Chips', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 2,
  		title: 'Переименовываем колонки',
  		subject: 'Оказалось, что мы неправильно назвали колонки в базе данных, и для приложения нужны другие имена полей.<br>Из таблицы <code>Chips</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>L1</code>, <code>L2</code> и <code>L3</code>, где последние три поля - это переименованные <code>L1Cache</code>, <code>L2Cache</code>, <code>L3Cache</code>',
  		data: { answer: 'SELECT ID, Name, L1Cache as L1, L2Cache as L2, L3Cache as L3 FROM Chips', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 3,
  		title: 'Вычисляемое поле', 
  		subject: 'Теперь, вместо трех колонок верните одну - суммарный кэш (хотя, конечно, складывать разноуровеные кэши - моветон).<br>Из таблицы <code>Chips</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code> и <code>Cache</code>, где поле <code>Cache</code> содержит сумму трех полей: <code>L1Cache</code>, <code>L2Cache</code>, <code>L3Cache</code>',
  		data: { answer: 'SELECT ID, Name, L1Cache + L2Cache + L3Cache as Cache FROM Chips', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 4,
  		title: 'Уникальный список',
  		subject: 'Под какие гнезда в нашей базе есть процессоры?<br>Напишите запрос возвращающий список различных (без повторений) значений поля <code>Socket</code> из таблицы <code>Chips</code><em>Для получения уникальных строк используйте ключевое слово <code>Distinct</code></em>',
  		data: { answer: 'SELECT DISTINCT Socket FROM Chips', order_key: 'Socket', distinct: true }
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 5,
		title: 'Только нужные записи',
		subject: 'Будем подбирать процессор - какие есть недорогие процессоры (скажем до 10000)?<br>Напишите запрос получающий только те строки таблицы <code>Chips</code>, где <code>Price</code> менее 10000',
		data: { answer: 'SELECT * FROM Chips WHERE Price < 10000', order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 6,
		title: 'Усложняем критерий отбора',
		subject: 'Недорогих процессоров немало. Чтож, чем больше кэш тем лучше - отберем процессоры с большим L2 или L3 кэшем<br>Напишите запрос получающий только те строки таблицы <code>Chips</code>, где <code>Price</code> менее 10000 и сумма <code>L2Cache</code> и <code>L3Cache</code> больше или равна 4096',
		data: { answer: 'SELECT * FROM Chips WHERE Price < 10000 AND L2Cache + L3Cache >= 4096', follows: true,  order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 7,
		title: 'Работаем с NULL',
		subject: 'Добавим еще критерий. Видеокарты в процессорах - не для тру-игроманов. К чему же нам процессоры где они встроены?<br>Напишите запрос получающий только те строки таблицы <code>Chips</code>, где <code>Price</code> менее 10000, сумма <code>L2Cache</code> и <code>L3Cache</code> больше или равна 4096, а <code>Graphics</code> равно <code>NULL</code>.',
		data: { answer: 'SELECT * FROM Chips WHERE Price < 10000 AND L2Cache + L3Cache >= 4096 AND Graphics IS NULL', follows: true, order_key: 'ID'}
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 8,
		title: 'Сортировка данных',
		subject: 'В приложении мы решили поддерживать сортировку по различным полям (для начала по кэшу второго уровня).<br>Напишите запрос получающий все строки таблицы <code>Chips</code> отсортированые в порядке возрастания <code>L2Cache</code>.',
		data: { answer: 'SELECT * FROM Chips ORDER BY L2Cache', order_key: 'L2Cache', ordered: 1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 9,
		title: 'Ограничение количества данных',
		subject: 'Теперь нас интересует топ-лист наиболее дорогоих процессоров.<br>Напишите запрос получающий первые 10 строк таблицы <code>Chips</code>, отсортированной в порядке убывания поля <code>Price</code>.',
		data: { answer: 'SELECT TOP 10 * FROM Chips ORDER BY Price DESC', order_key: 'Price', ordered: -1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 10,
		title: 'Собираем статистику',
		subject: 'Что же за данные у нас в базе - сколько там процессоров, что за цены?<br>Напишите запрос получающий по таблице <code>Chips</code> 1 строку с полями <code>Total</code> (общее количество записей), <code>MinPrice</code> (минимальное значение поля <code>Price</code>), <code>AvgPrice</code> (среднее значение поля <code>Price</code>), <code>MaxPrice</code> (максимальное значение поля <code>Price</code>)',
		data: { answer: 'SELECT COUNT(*) as Total, Min(Price) as MinPrice, Avg(Price) as AvgPrice, Max(Price) as MaxPrice from Chips' }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 11,
		title: 'Статистика с группировкой',
		subject: 'Теперь нас интересует распределение цены относительно гнезда процессора.<br>Напишите запрос который сгруппирует данные таблицы <code>Chips</code> по полю <code>Socket</code> и вернет несколько строк с полями: <code>Socket</code> (гнездо процессора), <code>N</code> (количество процессоров с таким гнездом) и <code>AvgPrice</code> (среднее значение поля <code>Price</code>)',
		data: { answer: 'SELECT Socket, COUNT(*) as N, Avg(Price) as AvgPrice FROM Chips GROUP BY Socket', order_key: 'Socket'}
	})
  end

  def down
	variant = MSSQLTaskVariant.find_by_index(4)
	MSSQLTask.where(task_variant: variant).destroy_all
	variant.destroy
  end
end
