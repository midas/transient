require File.expand_path( File.dirname(__FILE__) + '/spec_helper' )

shared_examples_for "Any transient" do
  it "should be Transient" do
    @instance.should respond_to(:effective_at)
    @instance.should respond_to(:expiring_at)
    @instance.should respond_to(:effective_through)
    @instance.should respond_to(:permanent?)
    @instance.should respond_to(:effective?)
    @instance.should respond_to(:expired?)
  end

  it "should report permanence" do
    @instance.effective_at = DateTime.beginning_of
    @instance.expiring_at = DateTime.end_of

    @instance.should be_permanent
    @instance.should be_effective
    @instance.should be_current
    @instance.should_not be_expired
    @instance.should_not be_past
    @instance.should_not be_future
  end

  it "should report temporariness" do
    @instance.effective_at = 5.minutes.ago
    @instance.expiring_at = 5.minutes.from_now

    @instance.should_not be_permanent
    @instance.should be_effective
    @instance.should be_current
    @instance.should_not be_expired
    @instance.should_not be_past
    @instance.should_not be_future
  end

  it "should report expiration" do
    @instance.effective_at = 10.minutes.ago
    @instance.expiring_at = 5.minutes.ago

    @instance.should_not be_permanent
    @instance.should_not be_effective
    @instance.should be_expired
  end

  it "should report upcomingness" do
    @instance.effective_at = 5.minutes.from_now
    @instance.expiring_at = 10.minutes.from_now

    @instance.should_not be_permanent
    @instance.should_not be_effective
    @instance.should_not be_current
    @instance.should_not be_expired
    @instance.should_not be_past
    @instance.should be_future
  end
  
  it "should respond to :effective" do
    @klass.respond_to?( :effective ).should be_true
  end

  it "should invoke callbacks around expire!" do
    @instance.should_receive(:before_expire!)
    @instance.should_receive(:after_expire!)
    @instance.expire!
  end
  
  it "should set effective_at to now if it was not explicitly set to something else" do
     @instance_no_dates.effective_at.should_not be_nil
  end
  
  it "should not allow records without an effective_at date to be saved" do
     @instance_no_dates.effective_at = nil
     @instance_no_dates.save.should be_false
  end
end