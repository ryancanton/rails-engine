require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    merchants = create_list(:merchant, 3)
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(1)
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_a(Array)
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    merchant_response = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_response.count).to eq(1)
    expect(merchant_response).to have_key(:data)
    expect(merchant_response[:data]).to be_a(Hash)
    expect(merchant_response[:data].count).to eq(3)

    merchant = merchant_response[:data]
    
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'show returns status 404 if merchant id is bad' do
    merchant = create(:merchant)
    get "/api/v1/merchants/#{merchant.id + 4}"

    expect(response.status).to eq(404)
  end
end