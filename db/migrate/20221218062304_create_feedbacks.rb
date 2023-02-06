class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.text :body, null: false
      t.belongs_to :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
