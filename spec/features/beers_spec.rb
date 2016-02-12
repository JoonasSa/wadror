require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:user) { FactoryGirl.create :user }

  it "is created if correct name" do
	sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
	fill_in('beer_name', with: 'Olutta')
    select('IPA', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "if incorrect name displays error message" do
	sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
	fill_in('beer_name', with: '')
    select('IPA', from: 'beer[style]')
 	select('Koff', from: 'beer[brewery_id]')
	click_button "Create Beer"

    expect(Beer.count).to eq(0)
	expect(page).to have_content 'be blank'
  end
end
