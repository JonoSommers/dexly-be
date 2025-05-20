class AddIndexesToCards < ActiveRecord::Migration[8.0]
  def change
    add_index :cards, :name
    add_index :cards, :set_name
  end
end
