require 'action_view'
require 'rss'
require 'yaml'
require 'fakeredis'
require 'http'

task :update_blog_posts do
  xml         = HTTP.get('https://uplink.tech/blog/rss/').to_s
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
