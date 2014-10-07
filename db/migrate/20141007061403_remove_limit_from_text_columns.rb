class RemoveLimitFromTextColumns < ActiveRecord::Migration
  def change
  	change_column :tasks, :data, :text, limit: nil
  	change_column :tasks, :subject, :text, limit: nil
  	change_column :task_variants, :data, :text, limit: nil 
  end
end
