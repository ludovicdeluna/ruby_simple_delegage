require 'delegate'

Dir[ File.join File.expand_path(File.dirname __FILE__), 'lib', '**', '*.rb' ]
.each do |file|
  require file
end
