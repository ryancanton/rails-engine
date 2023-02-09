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
end