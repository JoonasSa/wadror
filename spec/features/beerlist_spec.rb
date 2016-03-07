require 'rails_helper'

describe "beerlist page" do
  let!(:user) { FactoryGirl.create :user }

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows a known beer", :js => true do
  	visit signin_path
    fill_in('username', with:'Pekka')
    fill_in('password', with:'Foobar1')
    click_button('Log in')
    visit ngbeerlist_path
    #save_and_open_page
    page.all('tr')[1].text
    expect(page).to have_content "Fastenbier"
  end

  it "clicking style arranges beers in style order", js:true do
  	visit signin_path
    fill_in('username', with:'Pekka')
    fill_in('password', with:'Foobar1')
    click_button('Log in')
    visit ngbeerlist_path
    #save_and_open_page
    #page.all('a', :text => 'style').first.click
	#page.all('tr')[1].text	
	find('table').find('tr:nth-child(2)')
	click_link("style")
    
    expect(page).to have_content "Weizen"
  end

  it "clicking breweries arranges beers in brewery order", js:true do
  	visit signin_path
    fill_in('username', with:'Pekka')
    fill_in('password', with:'Foobar1')
    click_button('Log in')
    visit ngbeerlist_path
    #save_and_open_page
	page.all('tr')[1].text    
	click_link("brewery")
    
    expect(page).to have_content "Nikolai"
  end
end
