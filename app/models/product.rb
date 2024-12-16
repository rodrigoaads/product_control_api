class Product < ApplicationRecord
  belongs_to :admin

  validates :name, presence: true
  validates :price, presence: true

  def product_price
    self.price.to_f / 100
  end  

  def product_price=(value)
    self.price = (value.to_f * 100).round
  end  

  def formatted_price
    "R$ #{'%.2f' % product_price}"
  end 
  
  def map_product
    {
      id: self.id,
      name: self.name,
      price: self.formatted_price,
      quantity: self.quantity,
      registered_by: self.admin.name,
      created_at: self.created_at
    }
  end  
end
