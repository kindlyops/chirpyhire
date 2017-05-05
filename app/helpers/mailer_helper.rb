module MailerHelper
  def preview_text(body)
    Nokogiri::HTML(body).xpath('//text()').map(&:text).join(' ').squish
  end
end
