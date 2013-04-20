FactoryGirl.define do
  factory :statement do
    content "the world is flat"
  end

  factory :individual do
    name "Hec"
  end

  factory :agreement do
    url "MyString"
    statement
    individual
  end
end
