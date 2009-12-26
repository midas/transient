require File.dirname(__FILE__) + '/spec_helper'

describe Date do
  it "should define the beginning of time" do
    Date.should respond_to( :beginning_of )
  end

  it "should define the end of time" do
    Date.should respond_to( :end_of )
  end

  it "should format itself to a standard string" do
    now = Date.new
    now.to_standard_s.should == now.to_datetime.to_standard_s
  end
end

describe DateTime do
  it "should define the beginning of time" do
    DateTime.should respond_to( :beginning_of )
  end

  it "should define the end of time" do
    DateTime.should respond_to( :end_of )
  end

  it "should format itself to the standard string format" do
    now = DateTime.now
    now.to_standard_s.should == now.strftime( "%B %d, %Y %I:%M %p" )
  end
end

describe "all date and time classes" do
  it "should all report the same beginning of time" do
    DateTime.beginning_of.to_datetime.should == Date.beginning_of.to_datetime
  end

  it "should all report the same end of time" do
    DateTime.end_of.to_datetime.should == Date.end_of.to_datetime
  end
end