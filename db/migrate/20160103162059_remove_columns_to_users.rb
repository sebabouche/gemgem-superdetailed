class RemoveColumnsToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :password_digest, :string
    remove_column :users, :confirmation_token, :string
  end
end
