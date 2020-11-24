class Subscribe < ApplicationRecord
  validates :email, format: { with: /\A[^@]+@[^@]+\z/}, uniqueness: true
end
