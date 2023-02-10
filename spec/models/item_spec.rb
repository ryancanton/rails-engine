require 'rails_helper'

RSpec.describe Item do
  describe 'Relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :description }
    it { should validate_numericality_of :unit_price }
  end

  describe '#delete_solo_invoices' do
    it 'deletes any invoices containing only the item the method was called on' do
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

      item_1.delete_solo_invoices

      expect(Invoice.count).to eq(1)
      expect(Invoice.first.id).to eq(invoice_3.id)
    end
  end

  describe 'self.get_max_and_min' do
    it 'assigns default values for max and min if none are passed in' do
      merchant = create(:merchant)
      items = create_list(:item, 3, merchant_id: merchant.id)

      expect(Item.get_max_and_min({})).to eq({:max=>Item.maximum(:unit_price), :min=>0})
      expect(Item.get_max_and_min({min_price: 2.1, max_price: 21.12})).to eq({:max=>21.12, :min=>2.1})
    end
  end

  describe 'self.search_all' do
    it 'returns all items with matching names and descriptions if method is name' do
      merchant = create(:merchant)
      create_list(:item, 3, merchant_id: merchant.id)
      item_1 = merchant.items.create!(name: "Hxsfy", description: "does stuff", unit_price: 20.12)
      item_2 = merchant.items.create!(name: "Bob", description: "Hxsfy stuff", unit_price: 20.12)
      name_fragment = 'hxSf'
      expect(Item.search_all({name: name_fragment}, 'name')).to eq([item_1, item_2])

    end
    it 'returns all items between price range points if method is not name' do
      merchant = create(:merchant)
      items = create_list(:item, 12, merchant_id: merchant.id)
      results = Item.search_all({min_price: 12.99, max_price: 30.99}, 'price')
      if results != []
        results.each do |item|
          expect(item.unit_price <= 30.99).to eq(true)
          expect(item.unit_price >= 12.99).to eq(true)
        end
      end
    end
  end
end