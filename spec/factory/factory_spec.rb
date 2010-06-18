require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'factory/factory_fixture'

module Foxy  
  describe Factory do
    before(:each) do
      @clean_factory = Foxy::Factory.new :howrah
    end

    context ":howrah factory" do    
      it "should have an empty namespace registry" do
        @clean_factory.ns_registry.should == {}
      end      

      describe "#find_constant" do
        it "should raise ArgumentError if no arguments given" do
          lambda { @clean_factory.find_constant }.should raise_error ArgumentError
        end          
      
        it "should NOT find constant 'bad_class'" do
          lambda { @clean_factory.find_constant('bad_class') }.should raise_error Foxy::Factory::ConstantNotFoundError
        end          
      
        it "should find constant 'my_class' in 'howrah' namespace" do
          @clean_factory.find_constant('my_class').should
        end
      
        it "should find constant 'my_module' in 'howrah' namespace" do
          @clean_factory.find_constant('my_module').should
        end
      end
      
      describe "#find_class" do              
        it "should NOT find class 'my_module' in 'howrah' namespace as it's a module" do
          lambda { @clean_factory.find_class('my_module') }.should raise_error Foxy::Factory::ConstantIsNotClassError
        end                
      
        it "should find class 'my_class' in 'howrah' namespace as it's a module" do
          @clean_factory.find_class('my_class').should
        end          
      end

      describe "#find_module" do                            
        it "should NOT find module 'my_class' in 'howrah' namespace as it's a module" do
          lambda { @clean_factory.find_module('my_class') }.should raise_error Foxy::Factory::ConstantIsNotModuleError
        end          

        it "should find module 'my_module' in 'howrah' namespace as it's a module" do
          @clean_factory.find_module('my_module').should
        end          
      end
    end
  end
end