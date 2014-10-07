class MSSQLTaskVariant < TaskVariant
	data_field :host
	data_field :database
	data_field :username
	data_field :password

	def connect
		ActiveRecord::Base.sqlserver_connection({host: host, database: database, username: username, password: password})
	end
end