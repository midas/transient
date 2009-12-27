require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/transient_shared_spec')
require File.expand_path(File.dirname(__FILE__) + '/single_active_transient_shared_spec')

describe "Transient" do
  describe "having ActiveRecord extensions" do
    it "should respond to phone_number" do
      ActiveRecord::Base.respond_to?( :acts_as_transient ).should be_true
    end
  end

  describe "having models descending from ActiveRecord" do
    describe "that are not single active" do
      before(:each) do
        @instance = User.new( :name => 'John Smith', :effective_at => (DateTime.now - 1.days), :expiring_at => DateTime.end_of )
        @instance.save!
      end

      it_should_behave_like "Any transient"

      it "should agree that the InstanceMethods module is included" do
        User.included_modules.include?( Transient::ActiveRecordExtensions::InstanceMethods ).should be_true
      end

      it "should agree that the SingleActive module is not included" do
        User.included_modules.include?( Transient::ActiveRecordExtensions::SingleActive ).should be_false
      end
    end

    describe "that are single active" do
      before(:each) do
        @klass = ContactNumber
        @instance = @klass.new( :number => '012345678901', :location => 'home', :effective_at => (DateTime.now - 1.days) )
        @instance.save!
      end

      it_should_behave_like "Any transient"
      it_should_behave_like "Any transient that is single active"      

      it "should expire the current active before saving a new one" do
        @new_contact = ContactNumber.new( :number => '019876543210', :location => 'home', :effective_at => DateTime.now )
        @new_contact.save!
        @instance.reload
        @instance.expired?.should be_true
      end
    end
    
    describe "that are single active with check exists" do
      before(:each) do
        @klass = Address
        @instance = @klass.new( :street => '26 street', :location => 'home', :effective_at => (DateTime.now - 1.days) )
        @instance.save!
      end

      it_should_behave_like "Any transient"
      it_should_behave_like "Any transient that is single active"

      it "should expire the current active before saving a new one" do
        @new_address = Address.new( :street => '27 street', :location => 'home', :effective_at => DateTime.now )
        @new_address.save!
        @instance.reload
        @instance.expired?.should be_true
      end
    end
  end
end