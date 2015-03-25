module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
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
