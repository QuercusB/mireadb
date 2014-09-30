class CreateTaskLists < ActiveRecord::Migration
  def change
    create_table :task_lists do |t|
      t.integer :index, default: 0
      t.string :name
      t.references :course

      t.timestamps
    end
  end
end
