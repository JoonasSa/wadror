require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with correct name and style" do
    beer = Beer.create name:"Bisse", style:"Kalia"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end 

  it "is not saved if no name is set" do
    beer = Beer.create style:"Kalia"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved if no style is set" do
    beer = Beer.create name:"Bisse"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end