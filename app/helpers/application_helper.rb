module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    sort_icon = ''
    
    if column == sort_column
      if sort_direction == "asc"
        sort_icon = "<span class=\"glyphicon glyphicon-chevron-up\"></span>"
      elsif sort_direction == "desc"
        sort_icon = "<span class=\"glyphicon glyphicon-chevron-down\"></span>"
      end
    end
    
    link_to raw(sort_icon + title), {:sort => column, :direction => direction}, {:class => css_class}
  end

  def phone_format(num)
    number_to_phone(num, area_code: num != nil && num.size == 10)
  end
  
  def yes_no(value)
    if value == nil || value == false
      "No"
    else
      "Yes"
    end
  end
  
  def full_title(page_title = '')
    base_title = "TechScreen.net Interview Screening Application"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
    
  end
end
