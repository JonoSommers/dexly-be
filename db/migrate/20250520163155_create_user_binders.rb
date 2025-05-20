class CreateUserBinders < ActiveRecord::Migration[8.0]
  def change
    create_table :user_binders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :binder, null: false, foreign_key: true

      t.timestamps
    end
  end
end
