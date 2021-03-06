activate :directory_indexes
activate :autoprefixer
activate :i18n, mount_at_root: :de
activate :bootstrap_navbar
activate :sprockets

sprockets.append_path File.join(root, 'node_modules')

::BootstrapNavbar.configure do |config|
  config.root_paths = %w(/ /en)
end

if defined?(RailsAssets)
  RailsAssets.load_paths.each do |path|
    sprockets.append_path path
  end
end

activate :sitemap_ping do |config|
  config.host        = 'https://uplink.tech'
  config.after_build = false
end

I18n.exception_handler = ->(exception, locale, key, options) {
  raise "Missing translation key: #{key}, locale: #{locale}, options: #{options}"
}

page 'sitemap.xml', layout: false

# Ignore directory_index for 404.html.haml, so that 404.html
# is created which is then used as a custom 404 page by Netlify.
page '404.html', directory_index: false

ready do
  proxy '_redirects', 'netlify-redirects', ignore: true
end

ignore 'templates/*.html'

data.city_pages.each do |id, data|
  { de: 'stadt/', en: 'en/city/' }.each do |locale, prefix|
    proxy "#{prefix}#{id}/index.html", 'templates/city.html', locals: { city_id: id, city_data: data, locale: locale }
  end
end

data.jobs.each do |id, data|
  proxy "/jobs/#{id.gsub(/_/, '-')}/index.html", 'templates/job.html', locals: { job_id: id, job_data: data }
end

set :css_dir,                          'stylesheets'
set :js_dir,                           'javascripts'
set :images_dir,                       'images'
set :press_kit_google_drive_folder_id, '1_EuL5dbi42444QkCnx8O_l_xl5n_sIjG'
set :google_analytics_id,              'UA-67230464-1'
set :profiles, {
  twitter:     'https://twitter.com/uplink',
  facebook:    'https://www.facebook.com/UplinkHQ',
  xing:        'https://www.xing.com/companies/uplink',
  linkedin:    'https://www.linkedin.com/company/uplink-it-freelancer-network',
  instagram:   'https://www.instagram.com/uplinkhq',
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
set :media_coverage, [
  {
    outlet: :berlin_valley,
    link:   'https://drive.google.com/file/d/1xGNpZBnuK5Hp-cye8egxqGN_PtwZxoTa/view',
    text:   'Uplink ist ein Netzwerk für professionelle Freelance-Entwickler und hilft Berliner Unternehmen, die besten Entwickler der Stadt zu finden.',
    date:   Date.new(2016, 10, 11)
  }, {
    outlet: :deutsche_startups,
    link:   'https://www.deutsche-startups.de/2016/10/26/arbeiten-startups-erfolgreich-mit-freelancer-zusammen/',
    text:   'So arbeiten Startups erfolgreich mit Freelancern zusammen',
    date:   Date.new(2016, 10, 26)
  }, {
    outlet: :deutsche_startups,
    link:   'https://www.deutsche-startups.de/2017/12/20/entwickler-sollten-sich-selbststaendig-machen/',
    text:   'Entwickler sollten sich selbstständig machen',
    date:   Date.new(2017, 12, 20)
  }, {
    outlet: :debitoor,
    link:   'https://debitoor.de/blog/debitoor-community-manuel-meurer',
    text:   '2015 hast du mit Uplink eine Plattform für Freelance-Entwickler gegründet – und damit eine echte Nische besetzt.',
    date:   Date.new(2017, 3, 7)
  }, {
    outlet: :startup_valley_news,
    link:   'https://www.startupvalley.news/de/uplink-netzwerk-freelancer-it-recruitern/',
    text:   'Macht eine Liste eurer Mitbewerber und schreibt sie alle nacheinander an!',
    date:   Date.new(2017, 9, 29)
  }, {
    outlet: :t3n,
    link:   'https://t3n.de/news/freelancer-jobs-610810/',
    text:   'Uplink versteht sich als "Netzwerk für professionelle Freelance-Entwicklung".',
    date:   Date.new(2018, 5, 15)
  }, {
    outlet: :it_freelancer_magazin,
    link:   'https://www.it-freelancer-magazin.de/index.php/2019/02/28/gruender-von-uplink-it-freelancer-netzwerk-im-dialog/',
    text:   'Gründer von Uplink (IT-Freelancer-Netzwerk) im Dialog',
    date:   Date.new(2019, 2, 28)
  }
]

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
      super 'blank.gif', params.reverse_merge(class: 'lazy', data: { original: image_path(path) })
    else
      super
    end
  end

  def page_title_and_site_name
    [page_title, 'Uplink'].join(' | ')
  end

  def page_title
    @page_title || t(@id.gsub('-', '_'), scope: :page_titles)
  end

  def page_description
    @page_description || t(@id.gsub('-', '_'), scope: :page_descriptions)
  end

  def page_intro
    @page_intro || t(@id.gsub('-', '_'), scope: :page_intros)
  end

  def markdown(text)
    Kramdown::Document.new(text, input: 'GFM').to_html.chomp
  end

  def in_groups_of(data, number, fill_with = nil)
    if number.to_i <= 0
      raise ArgumentError,
        "Group size must be a positive integer, was #{number.inspect}"
    end

    if fill_with == false
      collection = data
    else
      # data.size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - data.size % number) % number
      collection = data.dup.concat(Array.new(padding, fill_with))
    end

    if block_given?
      collection.each_slice(number) { |slice| yield(slice) }
    else
      collection.each_slice(number).to_a
    end
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
