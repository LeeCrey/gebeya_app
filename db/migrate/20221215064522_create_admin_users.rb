class CreateAdminUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_users do |t|
      t.string :shop_name
      t.integer :longitude
      t.integer :latitude
      t.string :merchant_id, null: false, default: ""
      t.boolean :admin, null: false, default: false
      t.boolean :super_admin, null: false, default: false

      t.timestamps
    end
  end
end
