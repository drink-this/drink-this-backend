class AddUniqueToRatings < ActiveRecord::Migration[5.2]
  def change
    add_index :ratings, [:user_id, :cocktail_id], unique: true
  end
end
