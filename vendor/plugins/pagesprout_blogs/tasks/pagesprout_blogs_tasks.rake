# desc "Explaining what the task does"
# task :pagesprout_blogs do
#   # Task goes here
# end

namespace :pagesprout do
  desc "Sync required files from PageSprout blogs."
  task :syncBlogs => :syncCore do
    puts "Syncing Blogs migrations"
    system "rsync -ru vendor/plugins/pagesprout_blogs/db/migrate db"
  end
end
