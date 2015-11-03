FactoryGirl.define do
  factory :post do
    sequence(:public_id) {|i| "hello-world-#{ i }" }
    title "Hello World"
    body_markdown "Welcome to Cherry-Pickings!"
    published true
  end
end
