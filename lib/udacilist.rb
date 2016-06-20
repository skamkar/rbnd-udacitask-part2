require 'terminal-table'

class UdaciList
  include UdaciListErrors
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] ||= "Untitled List"
    @items = []
  end

  def add(type, description, options={})
    type = type.downcase
    if type_supported?(type)
      @items.push TodoItem.new(description, options) if type == "todo"
      @items.push EventItem.new(description, options) if type == "event"
      @items.push LinkItem.new(description, options) if type == "link"
    end
  end

  def delete(index)
    @items.delete_at(index - 1) if index_valid?(index)
  end

  def all
    rows = []
    puts ""
    puts @title
    @items.each_with_index do |item, position|
      rows << [(position + 1), item.details]
    end
    puts Terminal::Table.new :rows => rows
  end

  private

  def index_valid?(index)
    if @items[index]
      return true
    else
      raise UdaciListErrors::IndexExceedsListSize, "'#{index}' beyond item index range"
    end
  end

  def type_supported?(type)
    if ["todo","event","link"].include?(type)
      return true
    else
      raise UdaciListErrors::InvalidItemType, "'#{type}' not a valid item type." 
    end
  end
end
