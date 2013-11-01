# benchmark haml templates compiled with RubyVM::InstructionSequence
 
require "rubygems"
require "bundler/setup"
require "haml"
require "rbench"
 
class ViewHelpers
  include Haml::Helpers
 
  def initialize(cont)
    init_haml_helpers
  end
end
 
module Render
  extend self
  @@precompiled_templates = {}
  @@is_templates = {}
 
  def haml_precompiled_classic(template, options = {})
    precompiled = @@precompiled_templates[:"#{template}"]
    get_views_scope.instance_eval precompiled
  end
 
  def haml_precompiled_is(template, options = {})
    precompiled = @@is_templates[:"#{template}"]
    precompiled.eval
  end
 
  def haml_precompiled_template(template)
    unless @@precompiled_templates[:"#{template}"]
      # compile haml template to ruby-code
      @@precompiled_templates[:"#{template}"] =
        haml_engine_for(template).compiler.send(:precompiled_with_ambles, [])
 
      # compile haml-ruby-code to bitecode
      @@is_templates[:"#{template}"] =
        RubyVM::InstructionSequence.compile(
          "Render.get_views_scope.instance_eval do; #{@@precompiled_templates[:"#{template}"]}; end"
        )
    end
    @@precompiled_templates[:"#{template}"]
  end
 
  def haml_engine_for(template)
    tpl_file = File.join('test/templates', "#{template}.haml")
    template = File.open(tpl_file, 'r:utf-8', &:read)
    haml_engine = Haml::Engine.new(template, :format => :html5)
  end
 
  def get_views_scope
    @@views_scope ||= ViewHelpers.new(self)
  end
end
 
template = 'standard'
Render.haml_precompiled_template(template) # put to cache
Render.get_views_scope
 
RBench.run(3000) do
  column :classic, :title => "Classic"
  column :haml_is, :title => "Haml IS"
 
  report "Default" do
    classic { Render.haml_precompiled_classic(template) }
    haml_is { Render.haml_precompiled_is(template) }
  end
end