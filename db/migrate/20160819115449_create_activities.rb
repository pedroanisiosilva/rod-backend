class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :membership_id
      t.integer :run_id
      t.string :event_type
      t.text :note
      t.boolean :is_public

      t.timestamps null: false
    end
  end
end
