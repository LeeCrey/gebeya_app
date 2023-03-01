class CreateSearchHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :search_histories do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
