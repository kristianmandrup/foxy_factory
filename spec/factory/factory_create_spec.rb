require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'factory/factory_fixture'

module Foxy  
  describe Factory do
    before(:each) do
      @clean_factory = Foxy::Factory.new :howrah
    end                   
    
    context "clean factory" do   
      it "should NOT find constant 'base' in 'bad' namespace" do
        lambda { @clean_factory.create(:bad, 'base') }.should raise_error ArgumentError
      end          

      it "should create class 'my_nested_class' in 'my_module' namespace as it's a class" do
        @clean_factory.create(:my_class, :args => 2) do |p|
          p.number.should == 2
        end
      end          
       
      it "should create class 'my_nested_class' in 'my_module' namespace as it's a class" do
        @clean_factory.create(:my_module, :my_nested_class, :args => [2]) do |p|
          p.number.should == 2
        end
      end          

      it "should create class 'my_nested_class' in 'my_module' namespace as it's a class" do
        @clean_factory.create(:my_module, :my_nested_class, :args => [2, 'Goodbye']) do |p|
          p.number.should == 2
          p.say.should == "Goodbye"
        end
      end          
    end
  end
end