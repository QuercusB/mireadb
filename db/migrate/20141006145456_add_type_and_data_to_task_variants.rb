class AddTypeAndDataToTaskVariants < ActiveRecord::Migration
  def change
  	change_table :task_variants do |t|
  		t.string :type
  		t.string :data
  	end
  end
end
