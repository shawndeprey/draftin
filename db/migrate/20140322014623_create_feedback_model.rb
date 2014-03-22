class CreateFeedbackModel < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :title
      t.text :content
      t.boolean :handled, default: false
      t.belongs_to :user
      t.timestamps
    end
  end
end
