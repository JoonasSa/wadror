class AddBeerClubToUser < ActiveRecord::Migration
  def change
    add_column :users, :beer_club_id, :integer
  end
end
