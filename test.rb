require 'rubygems'
require 'ruby-debug'
require 'acts_as_euro'

class Foo
  include ActsAsEuro
  
  attr_accessor :amount
  acts_as_euro :amount
end

x = Foo.new
debugger
true

