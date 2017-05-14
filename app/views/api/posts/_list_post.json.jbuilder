json.cache! post do
  json.id post.public_id
  json.title post.title
  json.published_at post.published_at
  json.tags post.tags, partial: 'api/tags/tag', as: :tag
end
