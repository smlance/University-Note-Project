class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    add_index :users, :remember_token
    # The index is added so that the user can be retrieved
    # (indexed) by the remember_token.
  end
end
