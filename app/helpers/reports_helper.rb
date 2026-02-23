module ReportsHelper
  def sortable_header(column, title)
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    icon = column == params[:sort] ? (direction == "asc" ? " ↑" : " ↓") : ""

    link_to "#{title}#{icon}".html_safe, 
            reports_path(request.params.merge(sort: column, direction: direction)), 
            style: "color: inherit; text-decoration: none; font-weight: bold;"
  end
end