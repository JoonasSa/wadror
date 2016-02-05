json.array!(@beerclubs) do |beerclub|
  json.extract! beerclub, :id, :name, :founded, :city
  json.url beerclub_url(beerclub, format: :json)
end
