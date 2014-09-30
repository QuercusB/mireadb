require 'rails_helper'

RSpec.describe Course, :type => :model do
	it { should validate_presence_of :code }
	it { should validate_presence_of :name }
end
