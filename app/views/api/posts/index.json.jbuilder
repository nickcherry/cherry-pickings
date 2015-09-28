json.cache! @posts do
  json.array! @posts, partial: 'post', as: :post
end
