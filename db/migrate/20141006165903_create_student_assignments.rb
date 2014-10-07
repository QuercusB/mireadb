class CreateStudentAssignments < ActiveRecord::Migration
  def change
    create_table :student_assignments do |t|
      t.references :student, index: true
      t.references :task_variant, index: true

      t.timestamps
    end
  end
end
