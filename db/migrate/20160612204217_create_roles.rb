class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, uniq: true

      t.timestamps null: false
    end
    ['registered', 'banned', 'moderator', 'admin'].each do |role|
      Role.find_or_create_by({name: role})
    end
  end
end
