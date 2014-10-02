class Task < ActiveRecord::Base
	validates_presence_of :index
	validates_presence_of :subject
	validates_presence_of :type
	validates_presence_of :task_list
	validates_presence_of :task_variant

  belongs_to :task_list
  belongs_to :task_variant
  serialize :data, Hash
  
  def self.task_field(name)
  	puts "defining task field #{name}"
  	define_method("#{name}") {
  		data[name.to_s]
  	}
  	define_method("#{name}=") { |value|
  		data[name.to_s] = value
  	}
  end
end
