require 'font_awesome/sass/rails/helpers'

helpers FontAwesome::Sass::Rails::ViewHelpers

activate :directory_indexes
activate :autoprefixer
activate :i18n, mount_at_root: :de
activate :bootstrap_navbar
activate :sprockets

::BootstrapNavbar.configure do |config|
  config.root_paths = %w(/ /en)
end

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
set :form_url,                         '//formspree.io/hello@uplink.tech'
set :profiles, {
  twitter:     'https://twitter.com/UplinkHQ',
  facebook:    'https://www.facebook.com/UplinkHQ',
  xing:        'https://www.xing.com/companies/uplinkfreelancedevelopernetwork',
  linkedin:    'https://www.linkedin.com/company/uplink-freelance-developer-network',
  google_plus: 'https://plus.google.com/+UplinkTechNetwork',
  angellist:   'https://angel.co/uplinkhq',
  github:      'https://github.com/uplinkhq'
}
set :tech_images, {
  'JavaScript' => 'javascript.png',
  'Node.js'    => 'nodejs.svg',
  'React.js'   => 'react.png',
  'Angular.js' => 'angular.svg',

  'Ruby'       => 'ruby.png',
  'Rails'      => 'rails.svg',
  'Python'     => 'python.png',
  'Django'     => 'django.png',

  'Wordpress'  => 'wordpress.png',
  'TYPO3'      => 'typo3.png',
  'Drupal'     => 'drupal.svg',
  'Symfony'    => 'symfony.png',

  'Android'    => 'android.png',
  'iOS'        => 'ios.png',
  'Java'       => 'java.png',
  'Spring'     => 'spring.png'
}
set :media_coverage, {
  berlin_valley: {
    link: 'https://drive.google.com/file/d/0B4gIb1U545pcZzRwT3FqemhRYVU/view',
    text: 'Uplink ist ein Netzwerk für professionelle Freelance-Entwickler und hilft Berliner Unternehmen, die besten Entwickler der Stadt zu finden.'
  },
  deutsche_startups: {
    link: 'https://www.deutsche-startups.de/2016/10/26/arbeiten-startups-erfolgreich-mit-freelancer-zusammen/',
    text: 'So arbeiten Startups erfolgreich mit Freelancern zusammen'
  },
  debitoor: {
    link: 'https://debitoor.de/blog/debitoor-community-manuel-meurer',
    text: '2015 hast du mit Uplink eine Plattform für Freelance-Entwickler gegründet – und damit eine echte Nische besetzt.'
  }
}

helpers do
  # TODO: path localization should work with the `url_for` helper.
  # https://github.com/middleman/middleman/issues/1798
  # https://github.com/middleman/middleman/pull/1466
  def localized_path(path, fragment: nil, locale: I18n.locale)
    path = case
    when path.blank?   then locale == :de ? '/' : '/en/'
    when locale == :de then "/#{path}/"
    else                    "/en/#{t(path, scope: :paths, locale: locale, default: path)}/"
    end
    path << "##{fragment}" if fragment
    path
  end

  def other_locale
    (locales - [locale]).first
  end

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

  def page_title_and_site_name
    [page_title, 'Uplink'].join(' | ')
  end

  def page_title
    t current_page.data.id.gsub('-', '_'), scope: :page_titles
  end

  def page_description
    t current_page.data.id.gsub('-', '_'), scope: :page_descriptions
  end

  def page_intro
    t current_page.data.id.gsub('-', '_'), scope: :page_intros
  end

  def markdown(text)
    Kramdown::Document.new(text).to_html
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
