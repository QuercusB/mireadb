FactoryGirl.define do
	factory :task do
		sequence(:index)
		sequence(:subject) { |n| "Task subject #{n}" }
		type "DummyTask"
		task_list
		task_variant
	end
end
