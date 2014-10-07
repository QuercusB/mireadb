#encoding: UTF-8

class CreateDbCourse < ActiveRecord::Migration
  def up
  	Course.create!(code: 'DB', name: 'Введение в базы данных')
  end 

  def down
  end
end
