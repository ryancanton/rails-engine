require 'rails_helper'

RSpec.describe Customer do
  describe 'Relationships' do
    it { should have_many :invoices }
    it { should have_many :transactions }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:items).through(:invoice_items) }
  end
end