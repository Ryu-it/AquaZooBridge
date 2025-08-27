class DeduplicateFacilities < ActiveRecord::Migration[7.2]
  def up
    # 重複している施設名ごとにまとめる
    Facility.group(:name).having("COUNT(*) > 1").count.each_key do |dup_name|
      facilities = Facility.where(name: dup_name).order(:id)

      keep = facilities.first     # 最初のレコードを残す
      remove = facilities.offset(1) # 2件目以降を消す対象

      remove.each do |r|
        # 投稿を残す方に付け替え
        Post.where(facility_id: r.id).update_all(facility_id: keep.id)
        r.destroy!
      end
    end
  end

  def down
    # down は特に復元しない（実質不可逆）
    raise ActiveRecord::IrreversibleMigration
  end
end
