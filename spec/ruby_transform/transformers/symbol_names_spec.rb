require "spec_helper"

SymbolUnderscorer = RubyTransform::Transformers::SymbolNames.new do |name|
  name.underscore
end

describe SymbolUnderscorer do
  
  describe "method definition" do
    subject { %{def myMethod; end; def self.anotherMethod; end} }
    it { should transform_to("underscored", %{def my_method; end; def self.another_method; end}) }
  end
  
  describe "method call" do
    subject { %{myMethod.doSomething} }
    it { should transform_to("underscored", %{my_method.do_something}) }
  end
  
  describe "method arguments" do
    subject { %{my(argOne, argTwo)} }
    it { should transform_to("underscored", %{my(arg_one, arg_two)}) }
  end
  
  describe "block arguments" do
    subject { %{collection.each {|argOne, argTwo| something }} }
    it { should transform_to("underscored", %{collection.each {|arg_one, arg_two| something }}) }
  end
  
  describe "local variable" do
    subject { %{def my; myVariable = 1; myVariable; end} }
    it { should transform_to("underscored", %{def my; my_variable = 1; my_variable; end}) }
  end
  
  describe "instance variable" do
    subject { %{@myVariable = 1; @myVariable} }
    it { should transform_to("underscored", %{@my_variable = 1; @my_variable}) }
  end
  
  describe "class variable" do
    subject { %{@@myVariable = 1; @@myVariable; def my; @@myVariable = 1; end} }
    it { should transform_to("underscored", %{@@my_variable = 1; @@my_variable; def my; @@my_variable = 1; end}) }
  end
  
end
