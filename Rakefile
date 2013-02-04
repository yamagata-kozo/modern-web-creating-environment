require 'bundler'
Bundler.require
require './app'
require './static_file_maker'

desc 'Make static file (html, css, js, etc...) from site.json'
task 'make_static_file' do
  StaticFileMaker.new(App).run
end
