require 'bundler'
Bundler.require(:default, :development)

require './lib/rote'

autoload_rel 'actions'
autoload_rel 'models'
autoload_rel 'policies'
autoload_rel 'services'
autoload_rel 'views'
autoload_rel 'workers'

require_rel 'config'
require_rel 'routes'

include App
