class AddfollowrequestsCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :followrequest_count, :integer
  end

end
