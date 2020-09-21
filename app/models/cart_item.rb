class CartItem
  #CartItem改寫成放 sku 進來,相關方法及數變都要改寫
  attr_reader :sku_id, :quantity
  def initialize(sku_id, quantity = 1 )
    @sku_id = sku_id
    @quantity = quantity
  end

  def increment!(n = 1)
    @quantity += n
  end
  
  def product
    #Product.find_by(id: product_id)
    #實際上 product_id是一串亂碼,用find_by會找不到
    #Product.friendly.find(product_id)
    #因為要改成用 sku_id 來找到 product,所以要用 joins 先取聯集
    Product.joins(:skus).find_by(skus: { id: sku_id})
    #在聯集中找skus裡對應的sku_id
  end
  
  def total_price
    product.sell_price * quantity # product是"方法"!!
  end
end