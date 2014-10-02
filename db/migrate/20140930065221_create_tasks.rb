class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :task_list, index: true
      t.references :task_variant, index: true
      t.integer :index, default: 0
      t.string :type
      t.string :subject

      t.timestamps
    end
  end
end
