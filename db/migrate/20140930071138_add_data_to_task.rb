class AddDataToTask < ActiveRecord::Migration
  def change
  	change_table :tasks do |t|
  		t.string :data
  	end
  end
end
