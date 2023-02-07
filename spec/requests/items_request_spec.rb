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

  # it "can create a new book" do
  #   book_params = ({
  #                   title: 'Murder on the Orient Express',
  #                   author: 'Agatha Christie',
  #                   genre: 'mystery',
  #                   summary: 'Filled with suspense.',
  #                   number_sold: 432
  #                 })
  #   headers = {"CONTENT_TYPE" => "application/json"}
  
  #   # We include this header to make sure that these params are passed as JSON rather than as plain text
  #   post "/api/v1/books", headers: headers, params: JSON.generate(book: book_params)
  #   created_book = Book.last
  
  #   expect(response).to be_successful
  #   expect(created_book.title).to eq(book_params[:title])
  #   expect(created_book.author).to eq(book_params[:author])
  #   expect(created_book.summary).to eq(book_params[:summary])
  #   expect(created_book.genre).to eq(book_params[:genre])
  #   expect(created_book.number_sold).to eq(book_params[:number_sold])
  # end

  # it "can update an existing book" do
  #   id = create(:book).id
  #   previous_name = Book.last.title
  #   book_params = { title: "Charlotte's Web" }
  #   headers = {"CONTENT_TYPE" => "application/json"}
  
  #   # We include this header to make sure that these params are passed as JSON rather than as plain text
  #   patch "/api/v1/books/#{id}", headers: headers, params: JSON.generate({book: book_params})
  #   book = Book.find_by(id: id)
  
  #   expect(response).to be_successful
  #   expect(book.title).to_not eq(previous_name)
  #   expect(book.title).to eq("Charlotte's Web")
  # end

  # it "can destroy an book" do
  #   book = create(:book)
  
  #   expect(Book.count).to eq(1)
  
  #   delete "/api/v1/books/#{book.id}"
  
  #   expect(response).to be_successful
  #   expect(Book.count).to eq(0)
  #   expect{Book.find(book.id)}.to raise_error(ActiveRecord::RecordNotFound)
  # end
end