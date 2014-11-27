module WxRead
  class API < Grape::API
    format :json
    prefix "read"

    resource :readitem do
      desc "get read item "
      params do
        requires :length, :type => String, :desc => "获取多少readitem"
      end
      get do
        {"WRReadItem" => WxReadItem.limit(1)}.to_json
      end
    end
  end
end
