class CreateMembershipsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :communities, :programmers do |t|
      # t.index [:community_id, :programmer_id]
      # t.index [:programmer_id, :community_id]
    end
  end
end
