module ApplicationHelper
  #def sortable(column, title = nil)
  #  title ||= column.titleize
  #  css_class = (column == sort_column) ? "current #{sort_direction}" : nil
  #  direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
  #  link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  #end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def bootstrap_form_for(name, *args, &block)
    options = args.extract_options!
    form_for(name, *(args << options.merge(:builder => BootstrapFormBuilder)), &block)
  end
end
