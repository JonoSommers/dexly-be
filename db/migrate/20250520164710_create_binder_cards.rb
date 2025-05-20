class CreateBinderCards < ActiveRecord::Migration[8.0]
  def change
    create_table :binder_cards do |t|
      t.references :binder, null: false, foreign_key: true
      t.string :card_id
      t.foreign_key :cards, column: :card_id

      t.timestamps
    end
  end
end
