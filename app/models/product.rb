class Product < ApplicationRecord
  include CodeGenerator
  
  acts_as_paranoid

  has_rich_text :description
  has_one_attached :cover_image

  validates :name, presence: true
  validates :list_price, :sell_price, numericality: { greater_than: 0, allow_nil: true}
  validates :code, uniqueness: true

  belongs_to :vendor
  belongs_to :category, optional: true
  has_many :skus
  accepts_nested_attributes_for :skus, reject_if: :all_blank, allow_destroy: true

  scope :on_sell_products, -> { where(on_sell: 'true').includes(:vendor).order(updated_at: :desc).with_attached_cover_image }
  
  private
  def code_generator
    SecureRandom.hex(10)
  end
end
