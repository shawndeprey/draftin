namespace :tool do
  desc "Makes user an admin"
  task :admin, [:username] => :environment do |task, args|
    puts "\e[32mMaking \e[33m#{args[:username]}\e[32m an admin...\e[0m"
    user = User.find_by_username(args[:username])
    return puts "\e[32mUnable to make \e[33m#{args[:username]}\e[32m an admin...\e[0m" unless user
    user.update_attributes({admin:true})
    puts "\e[32mSuccessfully made \e[33m#{args[:username]}\e[32m an admin...\e[0m"
  end

  desc "send all users to mixpanel"
  task :user_mixpanel => :environment do
    User.where("id >= 0").find_in_batches do |users|
      users.each do |user|
        MetricsHelper::send_user_to_mixpanel(user)
      end
    end
  end
end