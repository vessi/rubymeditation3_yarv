require 'pp'
require 'ripper'
code = "10.times { |n| puts n }"
puts code
pp Ripper.lex(code)
code = <<STR
10.times do |n|
  puts n
end
STR
puts code
pp Ripper.lex(code)