class Cart
  attr_reader :items
  def initialize
    @items =[]
  end


  def add_item (product_id)
    found = @items.find { |item| item.product_id == product_id }
    if found 
      found.increment!
    else
      @items << CartItem.new(product_id)
    end
  end
  
  def total_price
    @items.reduce(0) { |sum, item| sum + item.total_price }
    #記得reduce(0) 要給初始值,不然會拿陣列中第一個物件當初始值
  end

  def to_serialize
    items = @items.map { |item| { "product_id" => item.product_id, 
                                "quantity" => item.quantity}}
    { "items" => items}
  end

  def empty?
    @items.empty?
  end

end