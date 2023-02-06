class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.belongs_to :admin_user, null: false, foreign_key: true
      t.belongs_to :customer, null: false, foreign_key: true

      t.timestamps
    end

    add_index :carts, %i[admin_user_id customer_id], unique: true
  end
end
