require 'byebug'
require 'chronic'

include UdaciListErrors

class TodoItem
  include Listable
  attr_accessor :priority
  attr_reader :description, :due

  def initialize(description, options={})
    @description = description
    @due = options[:due] ? Chronic.parse(options[:due]) : options[:due]
    @priority = options[:priority] if priority_exists?(options[:priority])
  end

  def details
    Listable.format_description(@description) + "due: " +
    Listable.format_date(@due) +
    Listable.format_priority(@priority)
  end

  def priority_exists?(priority)
    if ["low","medium","high",nil].include?(priority)
      return true
    else
      raise UdaciListErrors::InvalidPriorityValue, "'#{priority}' not a valid priority value." 
    end
  end
end
