module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def absolute_image_tag(*args)
    raw(image_tag(*args).sub /src="(.*?)"/, "src=\"http://#{ActionMailer::Base.default_url_options[:host]}" + '\1"')
  end
end
