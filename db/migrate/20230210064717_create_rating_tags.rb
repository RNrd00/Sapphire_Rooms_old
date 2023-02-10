class CreateRatingTags < ActiveRecord::Migration[6.1]
  def change
    create_table :rating_tags do |t|
      t.integer :rating_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
