class CreateBinders < ActiveRecord::Migration[8.0]
  def change
    create_table :binders do |t|
      t.string :name
      t.string :cover_image_url

      t.timestamps
    end
  end
end
