require 'spec_helper'

RSpec.describe GlobalNavHelper, type: :helper do
  let(:host) { Rails.configuration.mas_public_website_url }

  def locale
    'en'
  end

  describe 'category_url' do
    it 'creates the correct URL' do
      url = category_url('slug')
      expect(url).to eq("#{host}en/categories/slug")
    end
  end

  describe 'global_nav_url' do
    it 'prepends host to absolute path with no host' do
      url = global_nav_url('/my/path')
      expect(url).to eq("#{host}my/path")
    end

    it 'returns full URL unchanged' do
      original_url = 'http://example.com/my/path'
      url = global_nav_url(original_url)
      expect(url).to eq(original_url)
    end
  end
end
