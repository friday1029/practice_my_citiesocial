class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  validates :recipient, :tel, :address, presence: true

  before_create :generate_order_num

  private
  def generate_order_num
    self.num = SecureRandom.hex(5) unless num
    #最後面的 num 其實是呼叫 num 的方法
  end
end
