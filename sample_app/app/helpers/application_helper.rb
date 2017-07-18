module ApplicationHelper

  def full_title(page_title='')
    page_title.empty? ? base_title : format_titile(page_title)
  end

  private
  def base_title
    base_title = "Ruby on Rails Tutorial Sample App"
  end

  def format_titile(page_title)
    "#{page_title}|#{base_title}"
  end

end
