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

  def delete_mulitple(indices)
    indices.each {|index| self.delete(index)}
  end

  def change_priority(index, priority)
    if (index_valid?(index-1)) && (item_type(@items[index-1]) == "todo") && (TodoItem.new(nil, {:priority => priority}).priority_exists?(priority))
      @items[index-1].priority = priority
    end
  end

  def filter(type)
    self.print_list([type]) if type_supported?(type)
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
      if types.map(&:downcase).include?(item_type(item))
        rows << [(position + 1), item.details] 
      end
    end
    puts Terminal::Table.new :rows => rows
  end

  private

  def item_type(item)
    item.class.to_s[0..-5].downcase
  end

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
