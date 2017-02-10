xml.instruct!
xml.urlset 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  sitemap.resources.select { |resource| resource.path =~ /\.html/ }.each do |resource|
    xml.url do
      xml.loc config[:host] + resource.url
      xml.lastmod Date.today.to_time.iso8601
      xml.changefreq resource.data.changefreq || 'weekly'
      xml.priority resource.data.priority || '0.5'
    end
  end
end
