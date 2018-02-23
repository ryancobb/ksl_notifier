# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/deploy'
require "capistrano/scm/git"

require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rbenv'
require 'capistrano/puma'
require 'capistrano/sidekiq'

install_plugin Capistrano::Puma
install_plugin Capistrano::SCM::Git

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
