class AddAuthorGuidToWxReadItem < ActiveRecord::Migration
  def change
    add_column :wx_read_items, :authorGuid, :String
  end
end
