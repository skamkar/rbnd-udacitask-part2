require 'byebug'

include UdaciListErrors

class TodoItem
  include Listable
  attr_reader :description, :due, :priority

  def initialize(description, options={})
    @description = description
    @due = options[:due] ? Date.parse(options[:due]) : options[:due]
    @priority = options[:priority] if priority_exists?(options[:priority])
  end

  def details
    Listable.format_description(@description) + "due: " +
    Listable.format_date(@due) +
    Listable.format_priority(@priority)
  end

  private 

  def priority_exists?(priority)
    if ["low","medium","high",""].include?(priority)
      return true
    else
      raise InvalidPriorityValue, "'#{priority}' not a valid priority value." 
    end
  end
end
