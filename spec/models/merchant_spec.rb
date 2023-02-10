require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'self.find_by_name' do
    it 'returns the first matching merchant based on a name fragment' do
      merchant = Merchant.create!(name: "Hsxfy")
      name_fragment = 'hSxF'
      create_list(:merchant, 3)
      expect(Merchant.find_by_name(name_fragment)).to eq(merchant)
    end
  end
end