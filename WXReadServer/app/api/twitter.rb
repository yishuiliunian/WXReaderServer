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
            SearchWorker.perform_async(params[:keywords], 5)
            "aaa"
        end
      end

    end
  end
end

