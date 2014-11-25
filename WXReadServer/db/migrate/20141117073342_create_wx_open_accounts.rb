class CreateWxOpenAccounts < ActiveRecord::Migration
  def change
    create_table :wx_open_accounts do |t|
      t.string :openId
      t.string :name
      t.string :wechatId
      t.text :summary

      t.timestamps
    end
  end
end
