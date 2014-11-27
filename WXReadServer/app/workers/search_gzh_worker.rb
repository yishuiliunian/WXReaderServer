require "rest-client"
require "nokogiri"
require "uri"
require "rubypython"
require "json"

class SearchGzhWorker
  include Sidekiq::Worker

  def perform(gzhGuid, count)
    puts "begin search account"

    account = WxOpenAccount.find_by_openId(gzhGuid)
    if account == nil
      return
    end

    url = "http://weixin.sogou.com/gzh?openid=" + gzhGuid
    page = Nokogiri::HTML(RestClient.get(url))

    puts page
    contents = page.css("div.wxbox")
    puts contents
    puts "------------------------"
    puts contents.css("div.wx-rb")
    contents.css("div.wx-rb").each{ |xc|
      textBox = xc.css("div.txt-box")
      titleCss = textBox.css("h4").css("a")

      title = titleCss.text

      sourceUrl = titleCss["href"]

      summary = textBox.css("p").text

      readItem = WxReadItem.new
      readItem.autor = account.name
      readItem.sourceURL = sourceUrl
      readItem.title = title
      readItem.summary = summary
      readItem.authorGuid = account.openId

      readItem.save

      puts "get item #{readItem.title}"
    }

  end
end
