require 'rails_helper'

RSpec.describe 'Search API' do
  it 'can render a single merchant if a name fragment matches' do
    merchant = Merchant.create!(name: "Hsxfy")
    name_fragment = 'hSxF'
    create_list(:merchant, 3)

    get "/api/v1/merchants/find?name=#{name_fragment}"
    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result).to eq({:data=>{:id=>"#{merchant.id}", :type=>"merchant", :attributes=>{:name=>"Hsxfy"}}})
  end

  it 'can render all items with a matching name or description' do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)
    item_1 = merchant.items.create!(name: "Hxsfy", description: "does stuff", unit_price: 20.12)
    item_2 = merchant.items.create!(name: "Bob", description: "Hxsfy stuff", unit_price: 20.12)
    name_fragment = 'hxSf'

    get "/api/v1/items/find_all?name=#{name_fragment}"
    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result).to eq({:data=>
      [{:id=>"#{item_1.id}", :type=>"item", :attributes=>{:name=>"Hxsfy", :description=>"does stuff", :unit_price=>20.12, :merchant_id=>merchant.id}},
       {:id=>"#{item_2.id}", :type=>"item", :attributes=>{:name=>"Bob", :description=>"Hxsfy stuff", :unit_price=>20.12, :merchant_id=>merchant.id}}]})
  end

  it 'can render all items within a price range' do
    merchant = create(:merchant)
    items = create_list(:item, 12, merchant_id: merchant.id)
    get "/api/v1/items/find_all?min_price=1.99&max_price=37.99"
    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    if result[:data] != []
      result[:data].each do |item|
        expect(item[:attributes][:unit_price] >= 1.99).to eq(true)
        expect(item[:attributes][:unit_price] <= 37.99).to eq(true)
      end
    end
  end

  it 'returns status 400 is no query is passed through' do
    get "/api/v1/items/find_all"
    expect(response.status).to eq(400)

    get "/api/v1/merchants/find"
    expect(response.status).to eq(400)
  end

  it 'returns status 400 if query name param is empty' do
    get "/api/v1/items/find_all?name="
    expect(response.status).to eq(400)

    get "/api/v1/merchants/find?name="
    expect(response.status).to eq(400)
  end

  it 'returns status 400 if query has name and min/max price value' do
    get "/api/v1/items/find_all?name=bob&min_price=12.99"
    expect(response.status).to eq(400)
  end

  it 'returns status 400 if any price param is negative' do
    get "/api/v1/items/find_all?min_price=-12.99&max_price=0.00"
    expect(response.status).to eq(400)
  end

  it 'returns status 400 if min price is greater than max price' do
    get "/api/v1/items/find_all?min_price=12.99&max_price=0.00"
    expect(response.status).to eq(400)
  end
end