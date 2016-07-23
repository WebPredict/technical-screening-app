module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    sort_icon = determine_sort_icon(column, sort_column, sort_direction)
    
    link_to raw(sort_icon + title), {:sort => column, :direction => direction}, {:class => css_class}
  end

  def sortable_with_id(column, title, id_val)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    sort_icon = determine_sort_icon(column, sort_column, sort_direction)
    
    link_to raw(sort_icon + title), {:sort => column, :direction => direction, :id => id_val}, {:class => css_class}
  end

  def sortable_with_search(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    sort_icon = determine_sort_icon(column, sort_column, sort_direction)
    
    link_to raw(sort_icon + title), {:sort => column, :direction => direction, :remember_search => "true"}, {:class => css_class}
  end

  def determine_sort_icon(column, sort_column, sort_direction)
    sort_icon = ''
    if column == sort_column
      if sort_direction == "asc"
        sort_icon = "<span class=\"glyphicon glyphicon-chevron-up\"></span>"
      elsif sort_direction == "desc"
        sort_icon = "<span class=\"glyphicon glyphicon-chevron-down\"></span>"
      end
    end
    return sort_icon  
  end
  
  def phone_format(num)
    number_to_phone(num, area_code: num != nil && num.size == 10)
  end
  
  def truncate(value, size)
    if value == nil || value.size <= size
      value
    else
      value[0..size - 3] + "..."
    end
  end
  
  def yes_no(value)
    if value == nil || value == false
      "No"
    else
      "Yes"
    end
  end
  
  def full_title(page_title = '')
    base_title = "Technical Interview Screening Application"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
    
  end
end
