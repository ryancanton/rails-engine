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

  def self.get_max_and_min(search_params)
    if search_params[:min_price] == nil
      search_params[:min_price] = 0
    end
    if search_params[:max_price] == nil
      search_params[:max_price] = Item.maximum(:unit_price)
    end
    {max: search_params[:max_price], min: search_params[:min_price]}
  end

  def self.search_all(search_params, method)
    if method == 'name'
      self.where("name ILIKE ?", "%#{search_params[:name]}%")
        .or(Item.where('description ILIKE ?', "%#{search_params[:name]}%"))
    else
      max_and_min = self.get_max_and_min(search_params)
      Item.where('unit_price >= ?', max_and_min[:min]).where('unit_price <= ?', max_and_min[:max])
    end
  end
end