class Product < ApplicationRecord
  belongs_to :admin

  def product_price
    self.price.to_f / 100
  end  

  def product_price=(value)
    self.price = (value.to_f * 100).round
  end  

  def formatted_price
    "R$ #{'%.2f' % product_price}"
  end  
end
