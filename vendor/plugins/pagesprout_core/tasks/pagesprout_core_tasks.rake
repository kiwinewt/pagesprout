# desc "Explaining what the task does"
# task :pagesprout_core do
#   # Task goes here
# end

namespace :pagesprout do
  desc "Sync required files from PageSprout core."
  task :syncCore do
  
    puts "Syncing PageSprout Core Migrations"
    system "rsync -ru vendor/plugins/pagesprout_core/db/migrate db"
    
    puts "Syncing sample config files"
    system "rsync -ru vendor/plugins/pagesprout_core/config/files/ config"
    
    puts "Syncing default themes"
    system "rsync -ru vendor/plugins/pagesprout_core/assets/themes public"
    
  end
end
