require "nokogiri"
require "restclient"

wxSogouURLPrefix = "http://weixin.sogou.com/weixin?query="
wxSogouURLSubfix = "&_asf=www.sogou.com&_ast=1415087264&w=01019900&p=40040100&ie=utf8&type=2"
serachKeyWord = "ios"

searchURL = wxSogouURLPrefix + serachKeyWord + wxSogouURLSubfix
page = Nokogiri::HTML(RestClient.get(searchURL))
results = page.css("div.results")
puts results
