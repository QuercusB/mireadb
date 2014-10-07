class CreateFirstVariant < ActiveRecord::Migration
  def up
  	MSSQLTaskVariant.create!({
  		index: 1,
  		course: Course.first,
  		host: 'mireadb.cg3urejuymam.eu-west-1.rds.amazonaws.com',
  		database: 'phone_data',
  		username: 'quercus',
	  	password: 'mirea548'})
  end

  def down
  end
end
