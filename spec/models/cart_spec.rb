require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart){ Cart.new}
  describe "基本功能" do
    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了。" do
      cart.add_item(2)
      expect(cart).not_to be_empty
    end
    it "加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      3.times { cart.add_item(1) }
      2.times { cart.add_item(2) }
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.last.quantity).to be 2
    end
    it "商品可以放到購物車裡，也可以再拿出來" do
      # v1 = Vendor.create(title: 'ptt')
      # p1 = Product.create(name: "kk", list_price: '20', sell_price: '2', vendor: v1)
      p1 = FactoryBot.create(:product)
      cart.add_item(p1.id)
      expect(cart.items.first.product).to be_a Product
    end
    it "可以計算整台購物車的總消費金額" do
      p1 = create(:product, sell_price:5)
      p2 = create(:product, sell_price:10)
      3.times { cart.add_item(p1.id)}
      2.times { cart.add_item(p2.id)}
  
      expect(cart.total_price).to eq 35
    end
  end
  describe "進階功能" do
    it "可以將購物車內容轉換成 Hash 並存到 Session 裡" do
      p1 = create(:product, sell_price:5)
      p2 = create(:product, sell_price:10)
      3.times { cart.add_item(p1.id)}
      2.times { cart.add_item(p2.id)}
      expect(cart.to_serialize).to eq cart_hash
    end
    it "存放在 Session 的內容（Hash 格式），還原成購物車的內容" do
      cart= Cart.form_hash(cart_hash)
      expect(cart.items.first.quantity).to eq 3
      expect(cart.items.last.product_id).to eq 2
    end

    private
    def cart_hash
      {
        "items" => [
          {"product_id" => 1, "quantity" => 3},
          {"product_id" => 2, "quantity" => 2}
        ]
      }
    end
  end
end
