class AddColoumnOauthExpiresAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :oauth_expires_at, :datetime
  end
end
