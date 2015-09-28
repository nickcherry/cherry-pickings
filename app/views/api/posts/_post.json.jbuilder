json.cache! post do
  json.id post.id
  json.title post.title
  json.body_html post.body_html
  json.published_at post.published_at
  json.tags post.tags, partial: 'api/tags/tag', as: :tag
end
