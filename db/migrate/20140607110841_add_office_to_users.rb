class AddOfficeToUsers < ActiveRecord::Migration
  def change
     add_column :users, :office, :string
  end
end
