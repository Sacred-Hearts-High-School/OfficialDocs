class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps
    end
  end
end
