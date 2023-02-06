class CreateProductComments < ActiveRecord::Migration[7.0]
  def change
    create_table :product_comments do |t|
      t.text :body, null: false
      t.belongs_to :customer, null: false, foreign_key: true
      t.belongs_to :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
