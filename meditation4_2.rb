code = "puts 2+2"
puts RubyVM::InstructionSequence.compile(code).disasm