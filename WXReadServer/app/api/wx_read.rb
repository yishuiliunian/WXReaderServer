module WxRead
  module ErrorFormatter
    def self.call message, backtrace, options, evn
      {:response_type => 'error', :response => message}.to_json
    end
  end
  class API < Grape::API
    format :json
    prefix "read"

    rescue_from :all, :backtrace => true
    error_formatter :json, WxRead::ErrorFormatter

    before do
      error!("401 Unauthorized", 401) unless authenticated
    end

    helpers do

      def authenticated
        token = params[:access_token]
        if token == nil
          return false
        end

        storedToken = $redis.get(token)
        if storedToken == nil
          return false
        end
        $redis.expire(token, $TOKEN_EXPERIE_TIME)
        return true
      end
    end
    resource :readitem do
      desc "get read item "
#     params do
#       requires :length, :type => String, :desc => "获取多少readitem"
#     end
      get do
        WxReadItem.limit(20)
      end
    end

    resource :search do
      params do
        requires :keywords , :type => String, :desc => "搜索关键字"
      end

      route_param :keywords do
        get do
          WxWorkerBase.perform_async(params[:keywords], 1)
        end
      end
    end

    resource :search_feed do
      params do
        requires :keywords , :type => String, :desc => "搜索关键字"
      end

      route_param :keywords do
        get do
          SearchWorker.perform_async(params[:keywords],1)
        end
      end
    end
  end
end
