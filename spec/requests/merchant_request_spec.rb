require 'rails_helper'

RSpec.describe 'Merchant API' do
  it 'can return a merchant from an items id' do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    get "/api/v1/items/#{id}/merchant"

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
end