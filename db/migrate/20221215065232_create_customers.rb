class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.float :longitude
      t.float :latitude
      t.decimal :balance, null: false, default: 0.0

      t.timestamps
    end
  end
end
