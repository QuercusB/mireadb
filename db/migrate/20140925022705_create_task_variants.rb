class CreateTaskVariants < ActiveRecord::Migration
  def change
    create_table :task_variants do |t|
      t.integer :index, default: 0
      t.text :description
      t.references :course

      t.timestamps
    end
  end
end
