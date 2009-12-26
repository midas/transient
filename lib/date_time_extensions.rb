class DateTime
  def self.beginning_of
    DateTime.parse( "0000-01-01T00:00:00+00:00" )
  end

  def self.end_of
    DateTime.parse( "9999-12-31T00:00:00+00:00" )
  end

  def time?
    return !(hour == 0 && min == 0 && sec == 0 && sec_fraction == 0)
  end

  def to_standard_s
    return time? ? strftime( "%B %d, %Y %I:%M %p" ) : to_date.to_standard_s
  end
end

class Date
  def self.beginning_of
    DateTime.beginning_of.to_date
  end

  def self.end_of
    DateTime.end_of.to_date
  end

  def time?
    false
  end

  def to_standard_s
    strftime( "%B %d, %Y" )
  end
end

class Time
  def time?
    return !(hour == 0 && min == 0 && sec == 0)
  end

  def to_standard_s
    return time? ? to_datetime.to_standard_s : to_date.to_standard_s
  end
end