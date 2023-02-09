class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def delete_solo_invoices
    self.invoices.each do |invoice|
      if invoice.invoice_items.count == 1
        invoice.destroy
      end
    end
  end
end