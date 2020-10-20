# frozen_string_literal: true

class CreateReportComments < ActiveRecord::Migration[6.0]
  def change
    create_table :report_comments do |t|
      t.text :body, null: false
      t.references :user, foreign_key: true, null: false
      t.references :report, foreign_key: true, null: false

      t.timestamps
    end
  end
end
