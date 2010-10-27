require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "seer"
    gem.summary = %Q{Seer is a lightweight, semantically rich wrapper for the Google Visualization API.}
    gem.description = %Q{ Seer is a lightweight, semantically rich wrapper for the Google Visualization API. It allows you to easily create a visualization of data in a variety of formats, including area charts, bar charts, column charts, gauges, line charts, and pie charts.}
    gem.email = "corey@seologic.com"
    gem.homepage = "http://github.com/Bantik/seer"
    gem.authors = ["Corey Ehmke / SEO Logic"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.files = [
       "CONTRIBUTORS",
       "init.rb",
       "lib/seer.rb",
       "lib/seer/annotated_timeline.rb",
       "lib/seer/area_chart.rb",
       "lib/seer/bar_chart.rb",
       "lib/seer/chart.rb",
       "lib/seer/column_chart.rb",
       "lib/seer/gauge.rb",
       "lib/seer/geomap.rb",
       "lib/seer/line_chart.rb",
       "lib/seer/pie_chart.rb",
       "lib/seer/visualization_helper.rb",
       "LICENSE",
       "Rakefile",
       "README.rdoc",
       "rails/init.rb",
       "spec/spec.opts",
       "spec/spec_helper.rb",
       "spec/seer_spec.rb"
    ]
end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "seer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
