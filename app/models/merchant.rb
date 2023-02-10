class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_by_name(name)
    self.where('name ILIKE ?', "%#{name.downcase}%")
  end
end