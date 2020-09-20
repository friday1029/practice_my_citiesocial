FactoryBot.define do
  factory :order do
    num { "MyString" }
    recipient { "MyString" }
    tel { "MyString" }
    address { "MyString" }
    note { "MyText" }
    user { nil }
    state { "MyString" }
    pad_at { "2020-09-20 22:58:50" }
    trasaction_id { "MyString" }
  end
end
