require "./WXSniper.rb"
require "rest-client"
require "nokogiri"
require "./WXReadItem.rb"

class WXSearchSniper < WXSniper
  def initialize(_keyword)
    @keyword = _keyword
  end

  def process

    searchURL = "http://weixin.sogou.com/weixin?query=#{@keyword}&_asf=www.sogou.com&_ast=&w=01019900&p=40040100&ie=utf8&type=2&sut=1286&sst0=1416037220595&lkt=0%2C0%2C0"

    page = Nokogiri::HTML(RestClient.get(searchURL))

    if page == nil
      return nil
    end

    items = []

    publicContents = page.css("weixin-public")
    results = publicContents.css("results")
    page.css("div.weixin-public").css("div.results").css("div.wx-rb3").each {|x|
      imgBox = x.css("div.img_box2")
      sourceURL = imgBox.css("a")[0]["href"]


      item = WXReadItem.new
      item.sourceURL = sourceURL

      txtBox = x.css("div.txt-box")
      summary = txtBox.css("p")[0].text
      item.summary = summary

      title = txtBox.css("h4").css("a")[0].text
      item.title = title

      author = x.css("div.s-p").css("a")[0]["title"]
      item.author = author


      items.push(item)

    }
    return items
  end
end
