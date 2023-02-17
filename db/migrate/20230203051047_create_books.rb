class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :name, null: false
      t.string :introduce, null: false
      t.references :customer, null: false, foreign_key: { to_table: :customers }
      t.string :delete_key, null: false

      t.timestamps
    end
  end
end
