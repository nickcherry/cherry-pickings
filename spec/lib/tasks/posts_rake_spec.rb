require 'rails_helper'

describe 'posts:sync' do
  include_context 'rake'

  def invoke(folder)
    ENV['markdown_path'] = File.join('spec', 'support', 'files', 'markdown', folder)
    subject.reenable
    subject.invoke
  end

  let(:post_a) { Post.find_by public_id: 'a' }
  let(:post_b) { Post.find_by public_id: 'b' }

  it 'creates new posts' do
    expect{ invoke('batch_1') }.to change { Post.count }.from(0).to(2)

    expect(post_a.title).to eq 'A is for aardwolf'
    expect(post_a.tags.map(&:name)).to eq ['aardwolf']
    expect(post_a.published).to be true
    expect(post_a.published_at.utc.to_date).to eq Time.now.utc.to_date
    expect(post_a.image).to eq '/images/examples/a/aardwolf.gif'
    expect(post_a.body_html).to match %r{<p>An aardwolf is a nocturnal black-striped African mammal of the hyena family.</p>}

    expect(post_b.title).to eq 'B is for barology'
    expect(post_b.tags.map(&:name)).to eq ['barology']
    expect(post_b.published).to be false
    expect(post_b.published_at).to be nil
    expect(post_b.image).to eq '/images/examples/b/barology.gif'
    expect(post_b.body_html).to match %r{<p>Barology is the study of gravitation.</p>}
  end

  it 'updates existing posts' do
    invoke 'batch_1'
    expect{ invoke('batch_2') }.not_to change { Post.count }.from(2)

    expect(post_b.title).to eq 'B is for bushwa'
    expect(post_b.tags.map(&:name)).to eq ['bushwa']
    expect(post_b.published).to be true
    expect(post_b.published_at.utc.to_date).to eq Time.now.utc.to_date
    expect(post_b.image).to eq '/images/examples/b/bushwa.gif'
    expect(post_b.body_html).to match %r{<p>Bushwa is rubbish, nonsense.</p>}
  end

end
