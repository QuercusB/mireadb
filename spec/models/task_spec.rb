require 'rails_helper'

RSpec.describe Task, :type => :model do
	it { should validate_presence_of(:task_list) }
	it { should validate_presence_of(:task_variant) }
	it { should validate_presence_of(:subject) }
	it { should validate_presence_of(:type) }
	it { should validate_presence_of(:index) }
	it { should validate_presence_of(:title) }
	
	context 'by default' do
		subject { Task.new }
		
		its(:index) { should eq(0) }
	end
	
	let(:task_list) { FactoryGirl.create(:task_list) }
	let(:task_variant) { FactoryGirl.create(:task_variant) }
	
	it 'belongs to task_list which has many tasks' do
		task1 = FactoryGirl.create(:task, task_list: task_list)
		task2 = FactoryGirl.create(:task, task_list: task_list)
		expect(task1.task_list).to eq(task_list)
		expect(task2.task_list).to eq(task_list)
		expect(task_list.tasks).to include(task1)
		expect(task_list.tasks).to include(task2)
	end
	
	it 'belongs to task_variant' do
		task = FactoryGirl.create(:task, task_variant: task_variant)
		expect(task.task_variant).to eq(task_variant)
	end
	
	it 'has type column which provides polymorphic tasks' do
		task = DummyTask.new(title: 'Test', subject: "Test", task_list: task_list, task_variant: task_variant)
		task.save!
		reloadTask = Task.find(task.id)
		expect(reloadTask.class).to eq(DummyTask)
	end
	
	it 'subtypes can store their data in ''data'' column' do
		task = DummyTask.new(title: 'Test', subject: "Test", task_list: task_list, task_variant: task_variant)
		task.sql = "SELECT COUNT * FROM Task"
		task.count = 4
		task.save!
		task = Task.find(task.id)
		expect(task.sql).to eq("SELECT COUNT * FROM Task")
		expect(task.count).to eq(4)
	end
end

class DummyTask < Task	
	data_field :sql
	data_field :count
end
