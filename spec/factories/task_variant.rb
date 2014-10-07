FactoryGirl.define do
	factory :task_variant do
		sequence(:index)
		sequence(:description) { |n| "This is variant #{n}" }
		course
	end

	factory :mssql_variant, class: MSSQLTaskVariant do
		sequence(:index)
		sequence(:description) { |n| "This is MSSQL task variant #{n}" }
		course
		host 'mireadb.cg3urejuymam.eu-west-1.rds.amazonaws.com'
		database 'phone_data'
		username 'quercus'
		password 'mirea548'
	end
end
