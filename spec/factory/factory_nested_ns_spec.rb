require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'factory/factory_fixture'

module Foxy  
  describe Factory do
    before(:each) do
      @clean_factory = Foxy::Factory.new :howrah
    end                   
    
    context "clean factory" do   
      it "should NOT find constant 'base' in 'bad' namespace" do
        lambda { @clean_factory.find_constant(:bad, 'base') }.should raise_error Foxy::Factory::ConstantNotFoundError
      end          
       
      it "should find class 'my_nested_class' in 'my_module' namespace as it's a class" do
        @clean_factory.find_class(:my_module, 'my_nested_class').should_not be_nil
      end          
      
      it "should NOT find class 'my_nested_module' in 'my_module' namespace as it's a module" do
        lambda { @clean_factory.find_class(:my_module, :my_nested_module) }.should raise_error Foxy::Factory::ConstantIsNotClassError
      end          
      
      it "should find constant 'my_double_nested_class' in 'my_module::mynested_module' namespace" do
        @clean_factory.find_constant(:my_module, :my_nested_module, :my_double_nested_class).should_not be_nil 
      end                      
    end
  end
end