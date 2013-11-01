require 'rubygems'
require 'bundler/setup'
require 'rbench'

# simply the same as (1..n).inject(:*)
def fact(n, r)
  if n < 2
    r
  else
    fact(n - 1, n * r)
  end
end

def classic_fact(n)
  RubyVM::InstructionSequence.compile_option = {tailcall_optimization: false}
  fact(n, 1)
end

def tco_fact(n)
  RubyVM::InstructionSequence.compile_option = {tailcall_optimization: true}
  fact(n, 1)
end

RBench.run(30000) do
  column :classic, title: "Classic"
  column :tco, title: "Tail Call optimization"

  report "Small" do
    classic { classic_fact(5) }
    tco { tco_fact(5) }
  end
end

RBench.run(30000) do
  column :classic, title: "Classic"
  column :tco, title: "Tail Call optimization"

  report "Normal" do
    classic { classic_fact(50) }
    tco { tco_fact(50) }
  end
end

RBench.run(30000) do
  column :classic, title: "Classic"
  column :tco, title: "Tail Call optimization"

  report "Big" do
    classic { classic_fact(120) }
    tco { tco_fact(120) }
  end
end