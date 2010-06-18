puts "Fixture loaded"

class Basic          
  attr_reader :number, :say
  
  def initialize(number, say = "Hello", &block)
    @number = number
    @say = say
    if block
      block.arity < 1 ? obj.instance_eval(&block) : block.call(obj)
    end        
  end
end

module Howrah  
  class MyClass < Basic
    def initialize(number, say = "Hello", &block)
      super
    end
  end

  module MyModule
    class MyNestedClass < Basic
      def initialize(number, say = "Hello", &block)
        super
      end
    end

    module MyNestedModule
      class MyDoubleNestedClass
      end
    end
  end
end  
