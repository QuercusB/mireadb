class AddTitleToTasks < ActiveRecord::Migration
  def change
  	change_table :tasks do |t|
  		t.string :title
  	end
  end
end
