class CreateRecordings < ActiveRecord::Migration[5.2]
  def change
    create_table :recordings do |t|
      t.text :audio_data
      t.timestamps
    end
  end
end
