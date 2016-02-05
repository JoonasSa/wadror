class Beerclub < ActiveRecord::Base
  validates :name, length: { minimum: 4 }
  validates :name, uniqueness: true

  has_many :users, through: :membership
end
