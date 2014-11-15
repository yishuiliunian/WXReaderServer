class WXReadItem
  attr_accessor:sourceURL, :title, :author,  :updateDate, :summary
  def to_s
    "#{@sourceURL},\n title: #{@title}, \n summary: #{@summary} \n"
  end
end
