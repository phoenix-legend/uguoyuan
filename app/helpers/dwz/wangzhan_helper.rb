module Dwz::WangzhanHelper
  def get_tab_selected page_name
    if params[:action].to_s == page_name
      " selected"
    else
      ''
    end
  end
end
