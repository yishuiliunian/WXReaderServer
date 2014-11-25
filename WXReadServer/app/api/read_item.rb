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
        WxReadItem.limit(20)
      end
    end
  end
end
