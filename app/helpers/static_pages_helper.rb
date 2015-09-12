module StaticPagesHelper
  
  # TODO: get rid of these specific sort methods
  def tr_sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == tr_sort_column ? "current #{tr_sort_direction}" : nil
    direction = column == tr_sort_column && tr_sort_direction == "asc" ? "desc" : "asc"
    
    sort_icon = determine_sort_icon(column, tr_sort_column, tr_sort_direction)
    
    link_to raw(sort_icon + title), {:tr_sort => column, :tr_direction => direction}, {:class => css_class}
  end

end
