class ChangeDataColumnsToText < ActiveRecord::Migration
  def change
  	change_column(:tasks,:data,:text)
  	change_column(:task_variants,:data,:text)
  end
end
