require 'font_awesome/sass/rails/helpers'

helpers FontAwesome::Sass::Rails::ViewHelpers

activate :directory_indexes
activate :autoprefixer
activate :i18n, mount_at_root: :en
activate :bootstrap_navbar
activate :sprockets

if defined?(RailsAssets)
  RailsAssets.load_paths.each do |path|
    sprockets.append_path path
  end
end

activate :s3_sync do |config|
  config.aws_access_key_id     = ENV.fetch('AWS_ACCESS_KEY_ID')
  config.aws_secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY')
  config.bucket                = 'uplink.tech'
  config.region                = 'eu-central-1'
  config.after_build           = false
end

activate :cdn do |cdn|
  cdn.filter      = /\.(html|txt|xml)\z/i
  cdn.cloudflare  = {
    client_api_key: ENV.fetch('CLOUDFLARE_API_KEY'),
    email:          'manuel@krautcomputing.com',
    zone:           'uplink.tech',
    base_urls: [
      'https://uplink.tech'
    ]
  }
  cdn.cloudfront = {
    access_key_id:     ENV.fetch('CLOUDFRONT_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('CLOUDFRONT_SECRET_ACCESS_KEY'),
    distribution_id:   ENV.fetch('CLOUDFRONT_DISTRIBUTION_ID')
  }
end

activate :sitemap_ping do |config|
  config.host        = 'https://uplink.tech'
  config.after_build = false
end

I18n.exception_handler = ->(exception, locale, key, options) {
  raise "Missing translation key: #{key}, locale: #{locale}, options: #{options}"
}

page '/sitemap.xml', layout: false

set :css_dir,                          'stylesheets'
set :js_dir,                           'javascripts'
set :images_dir,                       'images'
set :press_kit_google_drive_folder_id, '0B4gIb1U545pcYUZ4NUd6TGpfd0U'

helpers do
  def image_tag(path, params = {})
    if params.delete(:lazy)
      super('blank.gif', params.reverse_merge(class: 'lazy', data: { original: image_path(path) })) <<
      content_tag(:noscript) do
        super path, params
      end
    else
      super
    end
  end

  def page_title
    [current_page.data.title || t(:tagline), 'Uplink'].join(' | ')
  end

  def page_description
    t :description
  end
end

configure :development do
  activate :livereload

  set :debug_assets, true
  set :host,         'http://localhost:4567'
end

configure :production do
  activate :gzip
  activate :asset_hash
  activate :minify_css
  activate :minify_javascript
  activate :imageoptim

  set :host, 'https://uplink.tech'
end
