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
  'setting': 'Setting',
  'language': "Language",
  'view_all': 'View All',
  'all_what': 'All @what',
  'managed_merchant': 'Managed Merchant',
  'owned_merchant': 'Owned Merchant'
};

Map<String,String> enLang = {}..addAll(_appsLang)..addAll(_settingLang);