class WxReadItem < ActiveRecord::Base
  validates_uniqueness_of :sourceURL
  def to_s
    "title:#{self.title} \n sourceURL:#{self.sourceURL} \n author:#{self.autor}"
  end
end
