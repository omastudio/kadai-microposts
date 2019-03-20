class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :micropost, foreign_key: true

      t.timestamps
      
      #お気に入りするUserとMicropostの組み合わせの情報は重複は認めない
      t.index [:user_id, :micropost_id], unique: true
    end
  end
end
