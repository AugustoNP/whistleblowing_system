class RenameEmailToEmailAddressInUsers < ActiveRecord::Migration[8.0]
  def change
    # rename_column :table_name, :old_column, :new_column
    rename_column :users, :email, :email_address
  end
end