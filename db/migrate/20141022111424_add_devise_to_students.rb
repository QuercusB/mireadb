class AddDeviseToStudents < ActiveRecord::Migration
  def self.up
    change_table(:students) do |t|
      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end

    add_index :students, :login,                :unique => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
