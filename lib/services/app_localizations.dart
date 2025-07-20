import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'data_management': 'Data Management',
      'backup_restore': 'Backup & Restore',
      'clear_all_data': 'Clear All Data',
      'system': 'System',
      'api_connection_status': 'API Connection Status',
      'about': 'About',
      'help_support': 'Help & Support',
      'privacy_policy': 'Privacy Policy',
    },
    'ar': {
      'settings': 'الإعدادات',
      'language': 'لغة',
      'theme': 'سمة',
      'light': 'ضوء',
      'dark': 'داكن',
      'data_management': 'إدارة البيانات',
      'backup_restore': 'استعادة النسخة الاحتياطية',
      'clear_all_data': 'امسح كل البيانات',
      'system': 'نظام',
      'api_connection_status': 'حالة اتصال API',
      'about': 'عن',
      'help_support': 'ساعد لدعم',
      'privacy_policy': 'سياسة الخصوصية',
    },
  };

  String? translate(String key) {
    return _localizedValues[locale.languageCode]?[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}