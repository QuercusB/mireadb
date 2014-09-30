FactoryGirl.define do
	factory :task_list do
		sequence(:index)
		sequence(:name) { |n| "Task list #{n}" }
		course
	end
end
