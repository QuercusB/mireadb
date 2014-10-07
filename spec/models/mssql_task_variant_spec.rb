describe MSSQLTaskVariant do
	it 'is inherited from TaskVariant' do
		expect(MSSQLTaskVariant.superclass).to eq(TaskVariant)
	end

	let(:course) { FactoryGirl.create(:course) }
	let(:variant) { FactoryGirl.create(:mssql_variant, course: course) }

	it 'has host, database, username, password' do
		variant = MSSQLTaskVariant.new(course: course)
		variant.host = '10.0.2.2'
		variant.database = 'db'
		variant.username = 'sa'
		variant.password = 'master'
		expect(variant.save).to eq(true)
		variant = MSSQLTaskVariant.find(variant.id)
		expect(variant.host).to eq('10.0.2.2')
		expect(variant.database).to eq('db')
		expect(variant.username).to eq('sa')
		expect(variant.password).to eq('master')
	end

	it 'creates mssql server connection on connect' do
		expect(ActiveRecord::Base).to receive(:sqlserver_connection).
			with({host: variant.host, database: variant.database, username: variant.username, password: variant.password})
		variant.connect
	end
end