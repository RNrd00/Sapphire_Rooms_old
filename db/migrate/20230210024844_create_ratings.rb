class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.string :name, null: false
      t.text :introduction, null: false
      t.integer :customer_id
      t.float :rate
      t.timestamps
    end
  end
end
