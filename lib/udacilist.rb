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

 # list.filter(item_type) that takes an item_type as input and displays only list items of that type if they exist, or alerts the user if there aren't any items of that type.

  def filter(type)
    self.print_list([type])
  end

  def all
    self.print_list
  end

  def print_list(types=nil)
    types ||= type_list
    rows = []
    puts ""
    puts @title
    @items.each_with_index do |item, position|
      if types.map(&:downcase).include?(item.class.to_s[0..-5].downcase)
        rows << [(position + 1), item.details] 
      end
    end
    puts Terminal::Table.new :rows => rows
  end

  private

  def type_list
    return ["todo","event","link"]
  end

  def index_valid?(index)
    if @items[index]
      return true
    else
      raise UdaciListErrors::IndexExceedsListSize, "'#{index}' beyond item index range"
    end
  end

  def type_supported?(type)
    if type_list.include?(type)
      return true
    else
      raise UdaciListErrors::InvalidItemType, "'#{type}' not a valid item type." 
    end
  end
end
