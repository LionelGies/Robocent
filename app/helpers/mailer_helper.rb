module MailerHelper
  def absolute_image_tag(*args)
    raw(image_tag(*args).sub /src="(.*?)"/, "src=\"http://#{ActionMailer::Base.default_url_options[:host]}" + '\1"')
  end
end