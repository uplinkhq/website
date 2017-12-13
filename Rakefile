require 'action_view'
require 'rss'
require 'yaml'
require 'fakeredis'
require 'fetchy'

task :update_blog_posts do
  xml         = Fetchy.new('https://blog.uplink.tech/feed').fetch
  feed        = RSS::Parser.parse(xml)
  pathname    = 'data/blog_posts.yml'
  items       = YAML.load_file(pathname)
  urls        = items.map { |item| item[:url] }
  image_regex = /<img.+?src="([^"]+)/

  feed.items.reverse.each do |item|
    url = item.link.split('?').first

    unless urls.include?(url)
      items.unshift(
        url:     url,
        image:   item.content_encoded[image_regex, 1],
        date:    item.pubDate.to_date,
        title:   item.title,
        content: ActionView::Base.full_sanitizer.sanitize(item.content_encoded)
      )
    end
  end

  File.write pathname, items.to_yaml
end
