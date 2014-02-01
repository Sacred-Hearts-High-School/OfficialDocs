class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :received_at
      t.string :received_no
      t.string :sent_from
      t.string :doc_type
      t.string :sent_no
      t.text :title
      t.belongs_to :office
      t.belongs_to :manager
      t.datetime :manager_get
      t.datetime :manager_back

      t.timestamps
    end
  end
end
