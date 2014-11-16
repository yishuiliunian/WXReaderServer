class CreateWxReadItems < ActiveRecord::Migration
  def change
    create_table :wx_read_items do |t|
      t.string :sourceURL
      t.string :title
      t.string :autor
      t.datetime :updateDate
      t.text :summary

      t.timestamps
    end
  end
end
