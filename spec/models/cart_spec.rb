require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart){ Cart.new}
  describe "基本功能" do
    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了。" do
      cart.add_sku(2)
      expect(cart).not_to be_empty
    end
    it "加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      3.times { cart.add_sku(1) }
      2.times { cart.add_sku(2) }
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.last.quantity).to be 2
    end
    it "可以一次加入多個相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      cart.add_sku(1,3)
      cart.add_sku(2,5)
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.last.quantity).to be 5
    end

    it "商品可以放到購物車裡，也可以再拿出來" do
      # v1 = Vendor.create(title: 'ptt')
      # p1 = Product.create(name: "kk", list_price: '20', sell_price: '2', vendor: v1)
      p1 = FactoryBot.create(:product, :with_skus)
      cart.add_sku(p1.skus.first.id)
      expect(cart.items.first.product).to be_a Product
    end
    it "可以計算整台購物車的總消費金額" do
      p1 = FactoryBot.create(:product, :with_skus, amount: 3, sell_price:5)
      #在"rails_helper.rb"加一些設定後,可以省略"FactoryBot"
      p2 = create(:product, :with_skus, amount: 5, sell_price:10 )

      3.times { cart.add_sku(p1.skus.first.id)}
      #2.times { cart.add_sku(p2.skus.first.id)}
      cart.add_sku(p2.skus.last.id, 2)
  
      expect(cart.total_price).to eq 35
    end
  end
  describe "進階功能" do
    it "可以將購物車內容轉換成 Hash 並存到 Session 裡" do
      p1 = create(:product, :with_skus, sell_price:5)
      p2 = create(:product, :with_skus, amount: 5, sell_price:10)
      3.times { cart.add_sku(p1.id)}
      cart.add_sku(p2.skus.last.id, 2)
      expect(cart.to_serialize).to eq cart_hash
    end
    it "存放在 Session 的內容（Hash 格式），還原成購物車的內容" do
      cart= Cart.form_hash(cart_hash)
      expect(cart.items.first.quantity).to eq 3
      expect(cart.items.last.sku_id).to eq 7
    end

    private
    def cart_hash
      {
        "items" => [
          {"sku_id" => 1, "quantity" => 3},
          {"sku_id" => 7, "quantity" => 2}
        ]
      }
    end
  end
end
