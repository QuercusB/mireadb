FactoryGirl.define do
	factory :task_variant do
		sequence(:index)
		sequence(:description) { |n| "This is variant #{n}" }
		course
	end
end
