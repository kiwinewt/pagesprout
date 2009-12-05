# Include hook code here

config.active_record.observers = :user_observer
  
config.to_prepare do
  ApplicationController.helper(AccountsHelper)
  ApplicationController.helper(AdminHelper)
  ApplicationController.helper(PagesproutHelper)
  ApplicationController.helper(FormEnhancementHelper)
  ApplicationController.helper(NavigationHelper)
  ApplicationController.helper(PagesHelper)
  ApplicationController.helper(PasswordHelper)
  ApplicationController.helper(RolesHelper)
  ApplicationController.helper(SearchHelper)
  ApplicationController.helper(SessionsHelper)
  ApplicationController.helper(ThemeHelper)
  ApplicationController.helper(UsersHelper)
end
  
#RECAPTCHA_PUBLIC_KEY = config.app_config['recaptcha_public_key']
#RECAPTCHA_PRIVATE_KEY = config.app_config['recaptcha_private_key']

Object.const_set("CMS_NAME", 'PageSprout')
Object.const_set("CMS_WEBSITE", 'http://pagesprout.com/')
Object.const_set("CMS_COMPANY", 'Kiwinewt.Geek Enterprises Ltd')
