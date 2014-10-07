require 'rails_helper'

RSpec.describe Student, :type => :model do
	it { should validate_presence_of(:first_name) }
	it { should validate_presence_of(:last_name) }
	it { should validate_presence_of(:login) }
	it { should validate_uniqueness_of(:login) }
end
