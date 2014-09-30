FactoryGirl.define do
	factory :course do
		sequence(:code) { |n| "COURSE-#{n}" }
		sequence(:name) { |n| "Course #{n}" }
	end
end
