# Foxy Factory #

Find Ruby kernel registered Constants, including Modules and Classes using convenient finder methods. 
Also create new instances factory style.

## Install ## 

<code>$ gem install foxy_factory</code> 

## Usage ## 

<code>require 'foxy_factory'</code> 

## Configuration ##

Imagine this namespace structure:

<pre><code>    
  class Basic
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
      def initialize(number, &block)
        super
      end
    end

    module MyModule
      class MyNestedClass < Basic
        def initialize(number, &block)
          super
        end
      end

      module MyNestedModule
        class MyDoubleNestedClass
        end
      end
    end
  end  
</code></pre>

Create factory with base namespace 'Howrah' that this factory will use as the root (or base) namespace

<code>factory = Foxy::Factory.new :howrah</code>

You can at any time change the implicit root for a given factory
<pre><code>
  factory = Foxy::Factory.new
  ...
  factory.base_namespace = :my_root
</code></pre>

## Find constant ##

Find constant `Howrah::MyClass`
<pre><code>factory.find_constant :my_class

=> Howrah::MyClass
</code></pre>

Find constant `Howrah::NonExistingClass` - should raise error
<pre><code>factory.find_constant :non_existing_class

=> error: ConstantNotFoundError
</code></pre>

Find constant `Howrah::MyModule`
<pre><code>factory.find_constant :my_module
  
=> Howrah::MyModule
</code></pre>

Find constant `Howrah::MyModule::MyNestedClass`

<pre><code>factory.find_constant :my_module, :my_nested_class
  
=> Howrah::MyModule::MyNestedClass
</code></pre>

Find constant `Howrah::MyModule::MyNestedModule::MyDoubleNestedClass`
<pre><code>factory.find_constant :my_module, :my_nested_module, :my_double_nested_class
  
=> Howrah::MyModule::MyNestedModule::MyDoubleNestedClass
</code></pre>

## Find module ##

Find module `Howrah::MyModule`
<pre><code>factory.find_module :my_module
=> Howrah::MyModule  
</code></pre>

Find module `Howrah::MyModule::MyNestedModule`
<pre><code>factory.find_module :my_module, :my_nested_module

=> Howrah::MyModule::MyNestedModule
</code></pre>

Find module `Howrah::MyModule::MyNestedModule::MyNestedClass` but not class!
<pre><code>factory.find_module! :my_module, :my_nested_class
  
=> error: ConstantIsNotModuleError
</code></pre>

## Find Class ##

Find class `Howrah::MyModule`
<pre><code>factory.find_class :my_module

=> error: ConstantIsNotClassError
</code></pre>

Find class `Howrah::MyModule::MyNestedModule::MyDoubleNestedClass`
<pre><code>factory.find_class :my_module, :my_nested_module, :my_nested_class
  
=> Howrah::MyModule::MyNestedModule::MyDoubleNestedClass
</code></pre>

## Create instance ##

<pre><code>  factory.create :my_module, :my_nested_class, :args => [2, 'Hello'] do |p|
    puts p.number * p.say
  end 
  
  => Hello Hello

  factory.create [], :my_class, :args => 2 do |p|
    puts p.number * "Hello "
  end 
</code></pre>

Ideas for improving the create argument handling are most welcome!

## Note on Patches/Pull Requests ##
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright ##

Copyright (c) 2010 Kristian Mandrup. See LICENSE for details.
