module Transient
  module ActiveRecordExtensions
    def self.included( base ) #:nodoc:
      base.extend ActsMethods
    end

    module ActsMethods
      def acts_as_transient( *args )
        include InstanceMethods unless included_modules.include?( InstanceMethods )
        options = args.extract_options!
        options.merge!( :single_active => false ) unless options[:single_active]
        #options.merge!( :check_exists => false ) unless options[:check_exists]
        if options[:single_active] != false
          include SingleActive unless included_modules.include?( SingleActive )
          class_attribute :transient_options
          self.transient_options = options
        end
      end
    end

    module InstanceMethods
      def self.included( base ) #:nodoc:
        base.instance_eval do
          def is_active_record_3?
            respond_to? :where
          end

          def scope_method_name
            is_active_record_3? ?
              :scope :
              :named_scope
          end
        end

        base.validates_presence_of :effective_at
        #base.validates_presence_of :expiring_at

        base.send( base.scope_method_name, :effective,
                                           lambda { { :conditions => ["effective_at <= ? AND (expiring_at IS NULL OR expiring_at > ?)",
                                                                      DateTime.now.utc, DateTime.now.utc] } } )

        if base.is_active_record_3?
          base.before_validation :check_and_set_effective_at, :on => :create
        else
          base.before_validation_on_create :check_and_set_effective_at
        end

        protected

        def check_and_set_effective_at
          self.effective_at = Time.zone.now if self.effective_at.nil?
        end

        public

        # Validates this record's effective dates occur in correct sequence (ie. effective_at is before
        # expiring_at).
        #
        def effective_at_earlier_than_expiring_at
          return unless self.effective_at && self.expiring_at

          unless self.effective_at.to_datetime <= self.expires_at.to_datetime
            self.errors.add( :effective_through, "effective at should be earlier than expiring at" )
          end

          super unless self.class.is_active_record_3?
        end
        base.validate :effective_at_earlier_than_expiring_at

        # The date this record expires.  Returns DateTime.end_of for records that have a
        # nil value in the database.
        #
        def expires_at
          return self.expiring_at.nil? ? DateTime.end_of : self.expiring_at
        end

        # The range this record is effective wihtin.
        #
        def effective_through
          self.effective_at.to_datetime..self.expires_at.to_datetime
        end

        # Sets the range this record is effective within.
        #
        def effective_through=( value )
          self.effective_at = value.begin.to_datetime
          self.expiring_at = value.end.to_datetime
        end

        # Returns true if this record's exiring_at date is equivalent to DateTime.end_of, otherwise false.
        #
        def permanent?
          self.expiring_at.to_datetime == DateTime.end_of
        end

        # Returns true if this is currently effective (ie. now is within the effective range), otherwise false.
        #
        def effective?
          self.effective_through === DateTime.now
        end

        # Returns true if this record is expired, otherwise false.
        #
        def expired?
          self.expires_at.to_datetime < DateTime.now
        end

        # Expires and saves this record.
        #
        def expire!
          before_expire! if self.respond_to?( :before_expire! )
          self.expiring_at = DateTime.now
          self.save
          after_expire! if self.respond_to?( :after_expire! )
        end

        # Returns true if this record is not yet effective, but will become effective at some point in the
        # future, otherwise false.
        #
        def future?
          self.effective_at.to_datetime > DateTime.now
        end

        # Alias for effective?.
        #
        def current?
          self.effective?
        end

        # Alias for expired?.
        #
        def past?
          self.expired?
        end
      end
    end

    module SingleActive
      def self.included( base ) #:nodoc:
        base.before_create :expire_current_active

        private

        def expire_current_active
          #if self.transient_options[:check_exists]
          #  exists_conditions = {}
          #  self.transient_options[:check_exists].each { |attr| exists_conditions.merge!( attr.to_sym => attributes[attr] ) }
          #  #cur = self.class.current.find( :first, :conditions => exists_conditions )
          #  return true if self.class.current.exists?( exists_conditions )
          #end

          conditions = {}
          self.transient_options[:single_active].each { |attr| conditions.merge!( attr.to_sym => attributes[attr] ) }
          old = self.class.effective.first( :conditions => conditions )
          old.expire! unless old.nil?
        end
      end
    end
  end
end
