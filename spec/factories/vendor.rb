FactoryBot.define do
  factory :vendor do
    title { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    online { false}
  end
end
