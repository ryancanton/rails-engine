require 'rails_helper'

describe "Items API" do
  it "sends a list of all items" do
    merchant = create(:merchant)
    items = create_list(:item, 3, merchant_id: merchant.id)
    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(1)
    expect(items).to have_key(:data)
    expect(items[:data]).to be_a(Array)
    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it "can get one item by its id" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    get "/api/v1/items/#{id}"

    expect(response).to be_successful
    item_response = JSON.parse(response.body, symbolize_names: true)

    expect(item_response.count).to eq(1)
    expect(item_response).to have_key(:data)
    expect(item_response[:data]).to be_a(Hash)
    expect(item_response[:data].count).to eq(3)

    item = item_response[:data]
    
    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item).to have_key(:type)
    expect(item[:type]).to eq("item")

    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'show returns 404 status if merchant id is bad' do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    get "/api/v1/items/#{id + 4}"

    expect(response.status).to eq(404)
  end

  it "can create a new item" do
    merchant = create(:merchant)
    item_params = {
      "name": "value1",
      "description": "value2",
      "unit_price": 100.99,
      "merchant_id": merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
  
    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can update an existing item" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    previous_name = Item.last.name
    item_params = { name: "Charlotte's Web" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
  
    expect(response).to be_successful
    expect(response.status).to eq(202)
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Charlotte's Web")
  end

  it 'update returns 404 status if item id is bad' do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    previous_name = Item.last.name
    item_params = { name: "Charlotte's Web" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id + 4}", headers: headers, params: JSON.generate({item: item_params})

    expect(response.status).to eq(404)
  end

  it "can destroy an item" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
  
    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{id}"
  
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "destroying an item destroys all invoices that have only that item" do
    merchant = create(:merchant)
    customer = create(:customer)
    item_1 = create(:item, merchant_id: merchant.id)
    item_2 = create(:item, merchant_id: merchant.id)
    invoice_1 = Invoice.create!(status: 'pending', merchant_id: merchant.id, customer_id: customer.id)
    invoice_2 = Invoice.create!(status: 'pending', merchant_id: merchant.id, customer_id: customer.id)
    invoice_3 = Invoice.create!(status: 'pending', merchant_id: merchant.id, customer_id: customer.id)
    InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 12, unit_price: item_1.unit_price)
    InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 11, unit_price: item_1.unit_price)
    InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_3.id, quantity: 10, unit_price: item_1.unit_price)
    InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_3.id, quantity: 9, unit_price: item_2.unit_price)
    
    delete "/api/v1/items/#{item_1.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(1)
    expect(Invoice.count).to eq(1)
    expect(Invoice.first.id).to eq(invoice_3.id)
  end

  it 'delete returns 404 status if item id id is bad' do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    delete "/api/v1/items/#{id + 4}"

    expect(response.status).to eq(404)
  end

  it "can get a list of items specific to a merchant" do
    merchant = create(:merchant)
    items = create_list(:item, 3, merchant_id: merchant.id)
    merchant2 = create(:merchant)
    items2 = create_list(:item, 3, merchant_id: merchant2.id)
    
    get "/api/v1/merchants/#{merchant.id}/items"
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    items[:data].each do |item|
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  it 'returns 404 status if merchant id is bad' do
    merchant = create(:merchant)
    items = create_list(:item, 3, merchant_id: merchant.id)
    get "/api/v1/merchants/#{merchant.id + 4}/items"

    expect(response.status).to eq(404)
  end
end