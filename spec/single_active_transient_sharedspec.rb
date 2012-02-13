require File.expand_path( File.dirname(__FILE__) + '/spec_helper' )

shared_examples_for "Any transient that is single active" do
  it "should agree that the InstanceMethods module is included" do
    @klass.included_modules.include?( Transient::ActiveRecordExtensions::InstanceMethods ).should be_true
  end

  it "should agree that the SingleActive module is included" do
    @klass.included_modules.include?( Transient::ActiveRecordExtensions::SingleActive ).should be_true
  end
end