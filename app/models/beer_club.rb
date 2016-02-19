class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def is_member?(user)
	members.include? user     
  end
end
