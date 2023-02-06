class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.float :discount
      t.string :origin
      t.integer :quantity, default: 1
      t.text :description
      t.belongs_to :category, null: false, foreign_key: true
      t.belongs_to :admin_user, null: false, foreign_key: true

      # For acts as votable
      t.integer :cached_weighted_score, default: 0
      t.integer :cached_weighted_total, default: 0
      t.float :cached_weighted_average, default: 0.0

      t.timestamps
    end

    add_index :products, %i[name]
  end
end
