class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.references :user, foreign_key: true
      t.references :cocktail, foreign_key: true
      t.integer :stars

      t.timestamps
    end
  end
end
