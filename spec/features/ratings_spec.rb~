require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user2 }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is displaying all ratings and their count on ratings page" do
	create_ratings_with_user
	visit ratings_path
	
	expect(page).to have_content 'Number of ratings 4'
	expect(page).to have_content 'iso 3 10'
	expect(page).to have_content 'Karhu 30'
  end
 
  it "is diplaying only/all ratings on users page" do
	visit signin_path
    fill_in('username', with: 'Kalle')
    fill_in('password', with: 'Foobar2')
    click_button('Log in')
	FactoryGirl.create :rating, beer_id:1, user_id:2
	FactoryGirl.create :rating2, beer_id:1, user_id:2
	FactoryGirl.create :rating3, beer_id:2, user_id:2
	create_ratings_with_user
	visit user_path(user2.id)

	expect(page).to have_content 'Has made 3 ratings'
	expect(page).to have_content 'iso 3 10'
	expect(page).to have_content 'iso 3 20'
	expect(page).to have_content 'Karhu 30'
  end
	
  it "if removed from user ratings, ratings are also removed from db" do
	visit signin_path
    fill_in('username', with: 'Kalle')
    fill_in('password', with: 'Foobar2')
    click_button('Log in')
	FactoryGirl.create :rating, beer_id:1, user_id:2
	FactoryGirl.create :rating2, beer_id:1, user_id:2
	FactoryGirl.create :rating3, beer_id:2, user_id:2
	visit user_path(user2.id)
	#aika purkkaa, tää hajoo jos tulee lisää linkkejä yläpalkkiin
	page.all('a')[10].click
	
	expect(user2.ratings.count).to eq(2)
  end
end

def create_ratings_with_user
    FactoryGirl.create :rating, beer_id:1, user_id:1
	FactoryGirl.create :rating2, beer_id:1, user_id:1
	FactoryGirl.create :rating3, beer_id:2, user_id:1
	FactoryGirl.create :rating4, beer_id:2, user_id:1
end
