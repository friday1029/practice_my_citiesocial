FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    list_price { Faker::Number.between(from: 50, to: 100) }
    sell_price { Faker::Number.between(from: 20, to: 50) }
    on_sell { false }
    vendor
  end
end
