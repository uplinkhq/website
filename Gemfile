source 'https://rubygems.org'

ruby '2.6.2'

# Return early if this file is parsed by the Bundler plugin DSL.
# This won't let us access dependencies in common-gems.
return if self.is_a?(Bundler::Plugin::DSL)

gem 'middleman', '~> 4.2'

# Load common gems
eval_gemfile 'common-gems/middleman/Gemfile'

gem 'kramdown',   '~> 1.13'
gem 'actionview', '~> 4.2',    require: false
gem 'http',       '5.0.0.pre', require: false # TODO: Use 5.x when released
gem 'fakeredis',  '~> 0.7'

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery.lazyload',      '~> 1.9'
  gem 'rails-assets-jquery-smooth-scroll', '~> 1.6'
  gem 'rails-assets-autosize',             '~> 3.0'
end
