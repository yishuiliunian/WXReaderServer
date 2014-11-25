class WxOpenAccount < ActiveRecord::Base
  validates_uniqueness_of :wechatId
end
