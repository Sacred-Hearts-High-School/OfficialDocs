class AddUseridToDocuments < ActiveRecord::Migration
  def change
      add_column :documents, :userid_get, :integer
      add_column :documents, :userid_back, :integer
  end
end
