module MailerHelper
  def absolute_image_tag(*args)
    raw(image_tag(*args).sub /src="(.*?)"/, "src=\"//#{ActionMailer::Base.default_url_options[:protocol]}#{ActionMailer::Base.default_url_options[:host]}" + '\1"')
  end
end