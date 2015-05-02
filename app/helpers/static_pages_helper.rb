module StaticPagesHelper
  
  def tr_sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    sort_icon = determine_sort_icon(column, sort_column, sort_direction)
    
    link_to raw(sort_icon + title), {:tr_sort => column, :tr_direction => direction}, {:class => css_class}
  end

end
