class CreateStudentTaskAttempts < ActiveRecord::Migration
  def change
    create_table :student_task_attempts do |t|
      t.references :student, index: true
      t.references :task, index: true
      t.boolean :done, default: false
      t.string :error_message
      t.string :type
      t.text :data

      t.timestamps
    end
  end
end
