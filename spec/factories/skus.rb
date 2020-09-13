FactoryBot.define do
  factory :sku do
    product { nil }
    spec { "MyString" }
    quantity { 1 }
    deleted_at { "2020-09-11 23:10:36" }
  end
end
