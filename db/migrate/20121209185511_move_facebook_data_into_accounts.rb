class MoveFacebookDataIntoAccounts < ActiveRecord::Migration
  def up
    User.find_each do |user|
      if user.uid.present?
        user.accounts.create! do |account|
          account.provider = 'facebook'
          account.uid = user.uid
          account.token = ''
        end
      end
    end
  end

  def down
    Account.where(:provider => 'facebook').each{ |a| a.user.update_column :uid, a.uid }.destroy_all
  end
end
