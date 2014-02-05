class ChangeReceivedAtType < ActiveRecord::Migration
  def change
     change_column :documents, :received_at, :datetime
  end
end
