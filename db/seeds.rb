if Rails.env.development?

  User.create!(
    name: 'Nick Cherry',
    email: 'nickcherryjiggz@gmail.com',
    password: '12345678'
  )

  tags = [
    Tag.create(name: 'SampleTag1'),
    Tag.create(name: 'SampleTag2'),
    Tag.create(name: 'SampleTag3')
  ]

  20.times do |i|
    Post.create!(
      title: "Sample Post #{ i + 1 }",
      published: true,
      published_at: (20 - i).days.ago,
      tags: tags.sample(rand(0..(tags.count - 1))),
      body_markdown: <<-body_markdown,

  __Lorem ipsum__ dolor sit amet, consectetur adipiscing elit. Mauris a [massa tempor](http://www.google.com), posuere ipsum nec, gravida urna. Praesent semper mauris a ipsum convallis ornare. Vestibulum sit amet interdum augue. Sed finibus placerat mi, quis sollicitudin sapien. Suspendisse potenti. Nulla semper tincidunt faucibus. Phasellus imperdiet ligula id massa efficitur, non mattis velit condimentum. Vivamus iaculis dictum massa, non tristique metus porta ac. Fusce tincidunt lorem non elit posuere scelerisque.

  _Sed rutrum_ porttitor ligula, a porttitor ante blandit vitae. Aenean dapibus dignissim rhoncus. Mauris efficitur, nunc vel finibus commodo, massa purus iaculis urna, ut tempus dolor quam quis quam. Nullam tortor ante, sodales dignissim finibus quis, varius ut ante. Nunc ultrices dui sit amet sem varius tristique. Nunc a consequat elit, eu mollis lectus. Aenean eleifend sem ac congue condimentum. Vivamus id eleifend quam. Pellentesque rhoncus risus sed nulla iaculis ultrices. Ut turpis ligula, luctus ac felis sed, efficitur blandit arcu. In ac libero non purus sagittis tincidunt ac eget ex.

  ### Sed vulputate enim a erat

  Quisque fringilla ultricies quam eu tristique. [Aliquam eget lacinia ligula.](http://www.google.com) Etiam feugiat arcu nec semper efficitur. Mauris pulvinar feugiat leo ac porttitor. Vivamus vitae sem id quam consequat fringilla semper sed ante. Phasellus iaculis leo eu libero vehicula, et condimentum turpis ultrices. Aliquam vel maximus leo, non tristique ex. Nulla efficitur tristique quam, eu tincidunt dolor. Phasellus nec imperdiet nisi. Vestibulum et erat sagittis, consectetur enim ac, molestie lacus. Proin accumsan felis ullamcorper lectus ornare viverra.

  - quisque eget
  - volutpat sem
  - a fringilla magna
  - nulla ac malesuada

  ### Sed cursus magna et est porta

  Phasellus tristique, erat eu hendrerit pharetra, metus massa viverra ipsum, eu pulvinar velit tortor sit amet ex. Morbi scelerisque orci et nibh ultricies viverra.

  1. tempus magna
  2. id sem sodales
  3. pellentesque

  Vivamus viverra ultricies nulla nec egestas. Sed iaculis sapien enim, blandit aliquet lacus fringilla sit amet. Sed vestibulum nibh nunc, id suscipit velit finibus id. Ut nec tincidunt ante.

  ``` coffeescript
  _.each @features, (feature) ->
    if feature.isAmazing() || feature.prettyImportant()
      @nick.implement(feature)
    else
      feature.archive()
  ```
  body_markdown
    )
  end

end
