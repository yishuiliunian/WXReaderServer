require "rest-client"
require "nokogiri"
require "uri"

class WxWorkerBase
  include Sidekiq::Worker

  def searchOpenAccount(keywords)
    keywords = URI::escape(keywords)
    puts "keywords is #{keywords}"

    searchURL = "http://weixin.sogou.com/weixin?type=1&query=#{keywords}&ie=utf8&_ast=1416206336&_asf=null&w=01029901&p=40040100&dp=1&cid=null"

    page = Nokogiri::HTML(RestClient.get(searchURL))
    if page == nil
      return nil
    end

    results = page.css("div.results").css("div._item")
    items = []

    results.each{|x|

      wxacc = WxOpenAccount.new

      name = x.css("div.txt-box").css("h3").text

      wxid = x.css("div.txt-box").css("h4").css("span").text
      wxid = wxid[4..wxid.length]

      openId = x["href"]
      openId = openId[12..openId.length]

      summary = x.css("div.txt-box").css("p.s-p3").css("span.sp-txt").text

      wxacc.openId = openId
      wxacc.name = name
      wxacc.wechatId = wxid
      wxacc.summary = summary

      items.push(wxacc)

      wxacc.save
    }

    items
  end
  def perform(name, count)
    items = searchOpenAccount(name)
    items.each{ |accout|
      puts "will search account #{accout.openId}"
      SearchGzhWorker.perform_async(accout.openId,1)
    }

  end

end

