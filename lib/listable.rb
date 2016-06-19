module Listable
  
  def self.format_description(description)
    "#{description}".ljust(25)
  end

  def self.format_priority(priority)
    value = " ⇧".colorize(:red) if priority == "high"
    value = " ⇨".colorize(:yellow) if priority == "medium"
    value = " ⇩".colorize(:blue) if priority == "low"
    value = "" if !priority
    return value
  end

  def self.format_date(*dates)
    if dates.count == 1
      dates[0] ? dates[0].strftime("%D") : "No due date"
    else
      date_range = dates[0].strftime("%D") if dates[0]
      date_range << " -- " + dates[1].strftime("%D") if dates[1]
      date_range = "N/A" if !date_range
      return date_range
    end
  end

  def self.format_name(site_name)
    site_name ? site_name : ""
  end

end
