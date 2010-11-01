require "spec_helper"

describe RubyTransform::Transformers::BlockMethodToProcifier.new do
  
  describe "a block call with method invocation" do
    subject { %{collection.map {|d| d.name }}}
    it { should transform_to("use Symbol#to_proc", %{collection.map(&:name)}) }
  end
  
  describe "a block call with chained method invocation" do
    subject { %{collection.map {|d| d.name.first }}}
    it { should transform_to("itself", subject) }
  end
  
  describe "a multiple-argument block call with method invocation" do
    subject { %{collection.map {|d, i| d.name + i }}}
    it { should transform_to("itself", subject) }
  end
  
end
