module Twitter
  class API < Grape::API
    format :json
    prefix "mysys"

    resource :visitors do
      desc "get all visitors"
      params do
        requires :keywords, :type => String, :desc => "search keywords"
      end
      route_param :keywords do
        get do
          key = params[:keywords]
          puts key
            SearchWorker.perform_async(key, 5)
            "aaa"
        end
      end

    end
  end
end

