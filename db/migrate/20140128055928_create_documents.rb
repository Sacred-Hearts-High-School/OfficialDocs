class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :received_at
      t.string :received_no
      t.string :sent_from
      t.string :doc_type
      t.string :sent_no
      t.text :title
      t.string :office
      t.belongs_to :user
      t.datetime :user_get
      t.belongs_to :user
      t.datetime :user_back
      t.belongs_to :user

      t.timestamps
    end
  end
end
