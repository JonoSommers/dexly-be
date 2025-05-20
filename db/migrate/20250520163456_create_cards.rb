class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards, id: false do |t|
      t.string :id, primary_key: true
      t.string :name
      t.string :set_name
      t.string :image_url
      t.string :supertype
      t.string :subtype
      t.string :rarity
      t.string :types

      t.timestamps
    end
  end
end
