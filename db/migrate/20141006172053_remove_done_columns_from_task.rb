class RemoveDoneColumnsFromTask < ActiveRecord::Migration
  def change
  	change_table :tasks do |t|
  		t.remove :done
  	end
  end
end
