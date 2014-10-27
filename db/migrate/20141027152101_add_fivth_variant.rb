#encoding: UTF-8

class AddFivthVariant < ActiveRecord::Migration
  def up
  	variant = MSSQLTaskVariant.create!({
  		index: 5,
  		course: Course.first,
  		host: 'mireadb.cg3urejuymam.eu-west-1.rds.amazonaws.com',
  		database: 'bookstore',
  		username: 'quercus',
	  	password: 'mirea548',
	  	description: <<-DESC
	  		Вам предостоит работать с базой данных книжного магазина.<br>
	  		В базе есть единственная (пока) таблица <code>Books</code> с полями:
	  		<ul>
	  			<li><code>ID</code> - идентификатор записи (int, суррогатный первичный ключ)</li>
	  			<li><code>Name</code> - название книги (nvarchar(255), обязательное)</li>
	  			<li><code>Author</code> - автор(ы) книги (nvarchar(255), необязательное)</li>
	  			<li><code>Price</code> - цена книги (decimal(15,2), обязательное)</li>
	  			<li><code>Rating</code> - рейтинг книги (int, необязательное)</li>
	  			<li><code>RatedBy</code> - количество людей указавших рейтинг книги (int, необязательное)</li>
	  			<li><code>Pages</code> - количество страниц в книге (int, обязательное)</li>
	  		</ul>
	  	DESC
	  	})

  	task_list = Course.first.task_lists.first

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 0,
  		title: 'Получаем всю информацию из таблицы',
  		subject: 'Получите всю информацию о книгах.<br>Напишите SQL-запрос, который вернет все данные (все строки со всеми полями) из таблицы <code>Books</code>',
  		data: { answer: 'SELECT * FROM Books', order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 1,
  		title: 'Только нужные поля',
  		subject: 'Теперь нам интересны не все поля, а только идентификатор, название, автор и цена.<br>Из таблицы <code>Books</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>Author</code> и <code>Price</code>',
  		data: { answer: 'SELECT ID, Name, Author, Price FROM Books', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 2,
  		title: 'Переименовываем колонки',
  		subject: 'Оказалось, что мы неправильно назвали колонки в базе данных, и для приложения нужна колонка "Authors".<br>Из таблицы <code>Books</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>Authors</code>, <code>Price</code>, где <code>Authors</code> - это переименованное поле <code>Author</code>',
  		data: { answer: 'SELECT ID, Name, Author as Authors, Price FROM Books', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 3,
  		title: 'Вычисляемое поле', 
  		subject: 'Вычислите удельную цену одной страницы для каждой книги (цена деленная на количество страниц).<br>Из таблицы <code>Books</code> получите данные по всем строкам с полями: <code>ID</code>, <code>Name</code>, <code>Price</code> и <code>PagePrice</code>, где поле <code>PagePrice = Price / Pages</code>',
  		data: { answer: 'SELECT ID, Name, Price, Price/Pages as PagePrice FROM Books', follows: true, order_key: 'ID' }
  	})

  	MSSQLTask.create!({
  		task_list: task_list,
  		task_variant: variant,
  		index: 4,
  		title: 'Уникальный список',
  		subject: 'Книги каких авторов присутствуют в нашем магазине?<br>Напишите запрос возвращающий список различных (без повторений) значений поля <code>Author</code> из таблицы <code>Books</code><em>Для получения уникальных строк используйте ключевое слово <code>Distinct</code></em>',
  		data: { answer: 'SELECT DISTINCT Author FROM Books', order_key: 'Author', distinct: true }
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 5,
		title: 'Только нужные записи',
		subject: 'Когда мы выбираем книгу, мы выбираем ее по тематике. Что в нашем магазине есть про C#?<br>Напишите запрос получающий только те строки таблицы <code>Books</code>, где <code>Name</code> содержит \'C#\'.<em>Для проверки содержит ли текстовое поле подстроку используйте конструкцию <code>Field like \'%<подстрока>%\'</code></em>',
		data: { answer: 'SELECT * FROM Books WHERE Name like \'%C#%\'', order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 6,
		title: 'Усложняем критерий отбора',
		subject: 'Чтож, выбор среди книг по \'C#\' есть, давайте теперь дополнительно отфильтруем их по рейтингу (и конечно, чтобы отзывов был не 1 и не 2)<br>Напишите запрос получающий только те строки таблицы <code>Books</code>, где <code>Name</code> содержит \'C#\', поле <code>Rating</code> равно 5 и <code>RatedBy</code> больше 2',
		data: { answer: 'SELECT * FROM Books WHERE Name like \'%C#%\' and Rating = 5 and RatedBy > 2', follows: true,  order_key: 'ID'}
	})

	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 7,
		title: 'Работаем с NULL',
		subject: 'Возможно среди книг по \'C#\' есть стоящие новинки - которые еще никто не успел оценить. Найдем их.<br>Напишите запрос получающий только те строки таблицы <code>Books</code>, где <code>Name</code> содержит \'C#\', а поле <code>Rating</code> не задано (равно <code>NULL</code>).',
		data: { answer: 'SELECT * FROM Books WHERE Name like \'%C#%\' AND Rating is null', follows: true, order_key: 'ID'}
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 8,
		title: 'Сортировка данных',
		subject: 'Пожалуй стоит посмотреть что есть хорошего из дешевых книг. Надо отсортировать книги по цене.<br>Напишите запрос получающий все строки таблицы <code>Books</code> отсортированые в порядке возрастания <code>Price</code>.',
		data: { answer: 'SELECT * FROM Books ORDER BY Price', order_key: 'Price', ordered: 1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 9,
		title: 'Ограничение количества данных',
		subject: 'Теперь нас интересует топ-лист наиболее дорогих книг.<br>Напишите запрос получающий первые 10 строк таблицы <code>Books</code>, отсортированной в порядке убывания поля <code>Price</code>.',
		data: { answer: 'SELECT TOP 10 * FROM Books ORDER BY Price DESC', order_key: 'Price', ordered: -1 }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 10,
		title: 'Собираем статистику',
		subject: 'Что же за данные у нас в базе - сколько там книг, что за цены?<br>Напишите запрос получающий по таблице <code>Books</code> 1 строку с полями <code>Total</code> (общее количество записей), <code>MinPrice</code> (минимальное значение поля <code>Price</code>), <code>AvgPrice</code> (среднее значение поля <code>Price</code>), <code>MaxPrice</code> (максимальное значение поля <code>Price</code>)',
		data: { answer: 'SELECT COUNT(*) as Total, Min(Price) as MinPrice, Avg(Price) as AvgPrice, Max(Price) as MaxPrice from Books' }
	})

  	MSSQLTask.create!({
		task_list: task_list,
		task_variant: variant,
		index: 11,
		title: 'Статистика с группировкой',
		subject: 'Теперь нас интересует распределение цены относительно рейтинга.<br>Напишите запрос который сгруппирует данные таблицы <code>Books</code> по полю <code>Rating</code> и вернет несколько строк с полями: <code>Rating</code> (рейтинг книги), <code>N</code> (количество книг с таким рейтингом) и <code>AvgPrice</code> (среднее значение поля <code>Price</code>)',
		data: { answer: 'SELECT Rating, COUNT(*) as N, Avg(Price) as AvgPrice FROM Books GROUP BY Rating', order_key: 'Socket'}
	})
  end

  def down
	variant = MSSQLTaskVariant.find_by_index(5)
	MSSQLTask.where(task_variant: variant).destroy_all
	variant.destroy
  end
end
