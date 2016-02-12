class CreateBeerClubs < ActiveRecord::Migration
  def change
    create_table :beer_clubs do |t|
      t.string :city
      t.integer :founded
      t.string :name

      t.timestamps null: false
    end
  end
end
