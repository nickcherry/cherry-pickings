json.cache! @posts do
  json.array! @posts, partial: 'list_post', as: :post
end
