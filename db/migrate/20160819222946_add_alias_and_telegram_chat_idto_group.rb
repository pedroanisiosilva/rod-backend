class AddAliasAndTelegramChatIdtoGroup < ActiveRecord::Migration
  def change
    add_column :groups, :group_alias, :string
    add_column :groups, :telegram_id, :string 	
  end
end
