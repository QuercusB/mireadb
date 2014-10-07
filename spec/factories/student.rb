FactoryGirl.define do
	factory :student do
		first_name 'Daniel'
		last_name 'Defaut'
		sequence(:login) { |n| "daniel_#{n}" }
	end
end