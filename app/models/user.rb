class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 15 }

  validates :password, length: { minimum: 4 },
                       format: {
                          with: /\d.*[A-Z]|[A-Z].*\d/,
                          message: "has to contain one number and one upper case letter"
                       }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  has_secure_password

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end	

  def favorite_style
	biggest = 0
	favorite = ""
	mappi = Rating.all.map{|x| x.beer.style}.uniq
	mappi.each do |style|
	  sum = beer_style_average_score(style)
	  if sum > biggest
		biggest = sum
		favorite = style
	  end
	end
	favorite
  end

  def beer_style_average_score(style)
	a = ratings.select{|rating| rating.beer.style == style}
	a.map(&:score).sum / a.count.to_f
  end

  def favorite_brewery
    biggest = 0
	favorite = ""
	mappi = Rating.all.map{|x| x.beer.brewery}.uniq
	mappi.each do |brewery|
	  sum = brewery_beer_average_score(brewery)
	  if sum > biggest
		biggest = sum
		favorite = brewery.name
	  end
	end
	favorite
  end

  def brewery_beer_average_score(brewery)
	a = ratings.select{|rating| rating.beer.brewery == brewery}
	a.map(&:score).sum / a.count.to_f
  end
end
