#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Cherry-Pickings"
    xml.author "Nick Cherry"
    xml.description "Fruits of full-stack development, gathered and documented by Nick Cherry."
    xml.link root_url
    xml.language "en"
    for post in @posts
      xml.item do
        xml.title post.title
        xml.author "Nick Cherry"
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link post_url(post)
        xml.guid post.id
        xml.description "<div>#{ post.body_html }</div>"
      end
    end
  end
end
