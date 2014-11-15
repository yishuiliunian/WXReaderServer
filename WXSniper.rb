require "./WXReadItem.rb"
class WXSniper
  attr_accessor:sniperID

  def process
    item = WXReadItem.new
    item.title = "a"
    item
  end

end
