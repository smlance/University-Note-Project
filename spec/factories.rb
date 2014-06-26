FactoryGirl.define do
  factory :user do
    name "John Smith"
    email "john@smith.com"
    password "foobarss"
    password_confirmation "foobarss"
  end
end
