FactoryGirl.define do
  factory :post do
    title "Hello World"
    public_id { title }
    body_markdown "Welcome to Cherry-Pickings!"
    published true
  end
end
