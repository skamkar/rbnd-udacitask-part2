require 'byebug'

class TodoItem
  include Listable
  attr_reader :description, :due, :priority

  def initialize(description, options={})
    @description = description
    @due = options[:due] ? Date.parse(options[:due]) : options[:due]
    @priority = options[:priority]
  end

  def details
    Listable.format_description(@description) + "due: " +
    Listable.format_date(@due) +
    Listable.format_priority(@priority)
  end
end
