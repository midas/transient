require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/transient_shared_spec')

describe "Transient" do
  describe "having ActiveRecord extensions" do
    it "should respond to phone_number" do
      ActiveRecord::Base.respond_to?( :acts_as_transient ).should be_true
    end
  end

  describe "having models descending from ActiveRecord" do
    describe "that are not single active" do
      before(:each) do
        @user = User.new( :name => 'John Smith', :effective_at => (DateTime.now - 1.days), :expiring_at => DateTime.end_of )
        @user.save!
        @instance = @user
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
        @contact_number = ContactNumber.new( :number => '012345678901', :location => 'home', :effective_at => (DateTime.now - 1.days) )
        @contact_number.save!
        @instance = @contact_number
      end

      it_should_behave_like "Any transient"
      
      it "should agree that the InstanceMethods module is included" do
        ContactNumber.included_modules.include?( Transient::ActiveRecordExtensions::InstanceMethods ).should be_true
      end

      it "should agree that the SingleActive module is included" do
        ContactNumber.included_modules.include?( Transient::ActiveRecordExtensions::SingleActive ).should be_true
      end

      it "should expire the current active before saving a new one" do
        @new_contact = ContactNumber.new( :number => '019876543210', :location => 'home', :effective_at => DateTime.now )
        @new_contact.save!
        @contact_number.reload
        @contact_number.expired?.should be_true
      end
    end
  end
end