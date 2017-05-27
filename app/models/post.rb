class Post < ActiveRecord::Base
  validates :public_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :body_markdown, presence: true

  before_save :prepare_public_id
  before_save :generate_body_markdown
  before_save :update_published_at

  has_many :post_tags
  has_many :tags, -> { order(:name) }, through: :post_tags

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(published_at: :desc) }

protected

  def prepare_public_id
    if public_id_changed?
      self.public_id = public_id.parameterize
    end
  end

  def generate_body_markdown
    self.body_html = parser.render(body_markdown)
  end

  def update_published_at
    if published_change == [false, true] && published_at.nil?
      self.published_at = Time.now
    elsif published_change == [true, false]
      self.published_at = nil
    end
  end

  def parser
    @parser ||= Parsers::PostBodyMarkdownParser.new(
      Renderers::PostBodyHtmlRenderer.new
    )
  end
end
