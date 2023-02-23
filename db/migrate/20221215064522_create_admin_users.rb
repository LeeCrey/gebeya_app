class CreateAdminUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_users do |t|
      t.string :shop_name
      t.float :longitude
      t.float :latitude
      t.string :merchant_id, null: false, default: ""
      t.boolean :admin, null: false, default: false
      t.boolean :super_admin, null: false, default: false
      t.integer :products_count, null: false, default: 0
      t.integer :orders_count, null: false, default: 0
      t.decimal :balance, null: false, default: 0.0

      t.timestamps
    end
  end
end
