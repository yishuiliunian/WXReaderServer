require "rest-client"
require "nokogiri"
require "uri"
require "rubypython"
require "json"

class SearchWorker
  include Sidekiq::Worker


  def searchItemForKeywokrds(keyword,pageNumber)
    keyword = URI::escape(keyword)
    puts "#{keyword}"

    searchURL = "http://weixin.sogou.com/weixin?query=#{keyword}&sut=2456&lkt=0%2C0%2C0&type=2&sst0=1416117968574&cid=null&page=#{pageNumber}&ie=utf8&p=40040100&dp=1&w=01019900&dr=1"

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

      item = WxReadItem.new
      item.sourceURL = sourceURL

      txtBox = x.css("div.txt-box")
      summary = txtBox.css("p")[0].text
      item.summary = summary

      title = txtBox.css("h4").css("a")[0].text
      item.title = title

      authorTexts = x.css("div.s-p").css("a")[0]

      author = authorTexts["title"]
      item.autor = author

      href = authorTexts["href"]
      if href.length > 12
        href = href[12..href.length - 1]
      end
      item.authorGuid = href


      items.push(item)
      item.save

    }
    puts items
    items
  end
  def perform(name, count)
    puts 'Doint hard work'
    for i in 1..10 do

      items = searchItemForKeywokrds(name,i)
      if items.size == 0
        break
      end
#     for each in items do
#        `python ./app/workers/exwords.py -u \"#{each.sourceURL}\"`
#     end

    end
    LogMailer.log_warning("stonedong@tencent.com").deliver
    puts 'end'
  end
end
