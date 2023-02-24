class DropAccountsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :accounts
  end
end
