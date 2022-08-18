const Map<String,String> _settingLang = {
  'theme_what': '@what theme',
  'theme': 'Theme',
  'system': 'System',
  'dark': 'Dark',
  'light': 'Light',
  'cancel': 'Cancel'
};

const Map<String,String> _appsLang = {
  'terms_of_service':'Terms of Service',
  'privacy_policy': 'Privacy Policy',
  'welcome': 'Welcome to ',
  'login': 'Login with Portalnesia',
  'logout': 'Logout',
  'logout_confirmation': "Logout from @what?",
  'setting': 'Setting',
  'language': "Language",
  'view_all': 'View All',
  'all_what': 'All @what',
  'managed_merchant': 'Managed Merchant',
  'owned_merchant': 'Owned Merchant'
};

const Map<String,String> _commonLang = {
  'add': 'Add',
  'add_what': 'Add @what',
  'del':"Delete",
  'del_what':"Delete @what",
  'remove':"Remove",
  'remove_what':"Remove @what",
  "wallet": "Wallet",
  "wait": "Please wait",
  "name": "Name",
  "name_what": "@what name",
  "description": "Description",
  "address": "Address",
  "save": "Save",
  "are_you_sure": "Are You Sure?",
  "back_confirmation": "Your changes have not been saved",
  "cancel": "Cancel",
  "yes": "Yes",
  "success":"Success",
  "saved":"Saved",
  "saved_what":"@what saved",
  "required":"Required"
};

Map<String,String> enLang = {}..addAll(_appsLang)..addAll(_settingLang)..addAll(_commonLang);