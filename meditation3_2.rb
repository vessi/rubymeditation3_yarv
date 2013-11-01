require 'ripper'
require 'pp'
code = <<STR
n = 5
puts n
STR
pp Ripper.sexp(code)