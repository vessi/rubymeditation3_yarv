require 'pp'
require 'ripper'
# one line
code = "10.times { |n| puts n }"
puts code
pp Ripper.lex(code)
# multi line
code = <<STR
10.times do |n|
  puts n
end
STR
puts code
pp Ripper.lex(code)
# syntax error
code = <<STR
10.times do |n
  puts n
end
STR
puts code
pp Ripper.lex(code)