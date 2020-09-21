class Cart
  attr_reader :items
  def initialize( hash =[])
    @items = hash
  end

  def self.form_hash( hash = nil )
    if hash && hash["items"]
      items = hash["items"].map { |item| 
        CartItem.new(item["sku_id"], item["quantity"])
      }
      cart = Cart.new(items)
    else
      Cart.new
    end
  end

  def add_sku (sku_id, quantity = 1 )
    found = @items.find { |item| item.sku_id == sku_id }
    if found 
      found.increment!(quantity)
    else
      @items << CartItem.new(sku_id, quantity)
    end
  end
  
  def total_price
    @items.reduce(0) { |sum, item| sum + item.total_price }
    #記得reduce(0) 要給初始值,不然會拿陣列中第一個物件當初始值
  end

  def to_serialize
    items = @items.map { |item| { "sku_id" => item.sku_id, 
                                "quantity" => item.quantity}}
    { "items" => items}
  end

  def empty?
    @items.empty?
  end

end
