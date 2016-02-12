require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "is not saved with too short password" do
    user = User.create username:"Pekka", password:"Sec", password_confirmation:"Sec"

    expect(user).to_not be_valid
    expect(User.count).to eq(0) 
  end

  it "is not saved with wrong password format" do
    user = User.create username:"Pekka", password:"secret", password_confirmation:"secret"

    expect(user).to_not be_valid
    expect(User.count).to eq(0) 
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  it "favorite style is working with one Lager" do 
	  user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"
	  beer = FactoryGirl.create(:beer)  
      FactoryGirl.create(:rating, score:10, beer:beer, user:user)

	  expect(user.favorite_style).to eq("Lager")
  end

  it "favorite style works with many beers" do
      user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"
	  beer = FactoryGirl.create(:beer)
	  beer2 = FactoryGirl.create(:beer)
	  beer3 = FactoryGirl.create(:beer2)
	  beer4 = FactoryGirl.create(:beer2)
      FactoryGirl.create(:rating, score:10, beer:beer, user:user)
	  FactoryGirl.create(:rating, score:20, beer:beer2, user:user)
	  FactoryGirl.create(:rating, score:10, beer:beer3, user:user)
	  FactoryGirl.create(:rating, score:21, beer:beer4, user:user)

	  expect(user.favorite_style).to eq("IPA")
  end

  it "favorite brewery works with many beers" do
      user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"
	  brewery1 = Brewery.create name:"Hartwall", year: 1950
	  beer = Beer.create name:"Kalia", brewery:brewery1, style: "Lager"
	  beer2 = Beer.create name:"Kaliax", brewery:brewery1, style: "Lager"
	  beer3 = FactoryGirl.create(:beer)
	  beer4 = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, score:20, beer:beer, user:user)
	  FactoryGirl.create(:rating, score:20, beer:beer2, user:user)
	  FactoryGirl.create(:rating, score:10, beer:beer3, user:user)
	  FactoryGirl.create(:rating, score:10, beer:beer4, user:user)

	  expect(user.favorite_brewery).to eq("Hartwall")
  end
	
  it "is displaying users favorite beer style correctly" do
	  user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"
	  visit signin_path
      fill_in('username', with: 'Pekka')
      fill_in('password', with: 'Secret1')
      click_button('Log in')
	  beer = FactoryGirl.create(:beer)
	  beer2 = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, score:10, beer:beer, user:user)
	  FactoryGirl.create(:rating, score:20, beer:beer2, user:user)
	  visit user_path(user.id)

	  expect(page).to have_content 'Favorite beer style: Lager'
  end

  it "is displaying users favorite brewery correctly" do
	  user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"
	  visit signin_path
      fill_in('username', with: 'Pekka')
      fill_in('password', with: 'Secret1')
      click_button('Log in')
	  beer = FactoryGirl.create(:beer)
	  beer2 = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, score:20, beer:beer, user:user)
	  FactoryGirl.create(:rating, score:20, beer:beer2, user:user)
	  visit user_path(user.id)

	  expect(page).to have_content 'Favorite brewery: anonymous'
  end

end # describe User

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating user, score
  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end
