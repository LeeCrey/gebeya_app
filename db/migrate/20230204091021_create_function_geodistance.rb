class CreateFunctionGeodistance < ActiveRecord::Migration[7.0]
  def change
    create_function :geodistance
  end
end
