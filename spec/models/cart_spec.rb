require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "基本功能" do
    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了。" do
      cart = Cart.new
      cart.add_item(2)
      expect(cart.empty?).to be false
    end
    it "加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      cart = Cart.new
      3.times { cart.add_item(1) }
      2.times { cart.add_item(2) }
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.last.quantity).to be 2
    end
    it "商品可以放到購物車裡，也可以再拿出來" do
      cart = Cart.new
      v1 = Vendor.create(title: 'ptt')
      p1 = Product.create(name: "kk", list_price: '20', sell_price: '2', vendor: v1)
      cart.add_item(p1.id)
      expect(cart.items.first.product).to be_a Product
    end
  end
end
