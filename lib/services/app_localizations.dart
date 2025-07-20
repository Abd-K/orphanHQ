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
      // App Layout & Navigation
      'orphans': 'Orphans',
      'supervisors': 'Supervisors',
      'emergency': 'Emergency',
      'settings': 'Settings',

      // Orphan List Page
      'add_orphan': 'Add Orphan',
      'total_orphans': 'Total Orphans',
      'missing': 'Missing',
      'active': 'Active',
      'no_orphans_found': 'No orphans found',
      'add_first_orphan': 'Add First Orphan',
      'showing_orphans': 'Showing {filter} orphans ({count})',
      'no_orphans_found_for_filter': 'No {filter} orphans found',
      'try_different_filter': 'Try selecting a different filter',
      'show_all_orphans': 'Show All Orphans',

      // Supervisor View Page
      'add_supervisor': 'Add Supervisor',
      'total_supervisors': 'Total Supervisors',
      'inactive': 'Inactive',
      'no_supervisors_found': 'No supervisors found',
      'add_first_supervisor': 'Add First Supervisor',
      'showing_supervisors': 'Showing {filter} supervisors ({count})',
      'no_supervisors_found_for_filter': 'No {filter} supervisors found',
      'show_all_supervisors': 'Show All Supervisors',

      // Emergency Dashboard
      'emergency_dashboard': 'Emergency Dashboard',
      'missing_orphans': 'Missing Orphans',
      'unsupervised_orphans': 'Unsupervised Orphans',
      'inactive_supervisors': 'Inactive Supervisors',
      'all_clear': 'All Clear!',
      'all_orphans_safe': 'All orphans are accounted for and safe',
      'show_all_emergency_cases': 'Show All Emergency Cases',

      // Settings Page
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
      // Subtitles
      'manage_backups': 'Manage your data backups',
      'delete_all_data': 'Permanently delete all data (creates backup first)',
      'view_server_status': 'View server and tunnel status',
      'app_version': 'Orphan HQ v1.0.0',
      'get_help': 'Get help and contact support',
      'read_privacy_policy': 'Read our privacy policy',
      'notifications': 'Notifications',
      'notifications_subtitle': 'Enabled (Not implemented yet)',


    },
    'ar': {
      // App Layout & Navigation
      'orphans': 'الأيتام',
      'supervisors': 'المشرفون',
      'emergency': 'طوارئ',
      'settings': 'الإعدادات',

      // Orphan List Page
      'add_orphan': 'إضافة يتيم',
      'total_orphans': 'إجمالي الأيتام',
      'missing': 'مفقود',
      'active': 'نشيط',
      'no_orphans_found': 'لم يتم العثور على أيتام',
      'add_first_orphan': 'إضافة اليتيم الأول',
      'showing_orphans': 'عرض {filter} أيتام ({count})',
      'no_orphans_found_for_filter': 'لم يتم العثور على أيتام {filter}',
      'try_different_filter': 'جرب تحديد مرشح مختلف',
      'show_all_orphans': 'عرض كل الأيتام',

      // Supervisor View Page
      'add_supervisor': 'إضافة مشرف',
      'total_supervisors': 'إجمالي المشرفين',
      'inactive': 'غير نشط',
      'no_supervisors_found': 'لم يتم العثور على مشرفين',
      'add_first_supervisor': 'إضافة المشرف الأول',
      'showing_supervisors': 'عرض {filter} مشرفين ({count})',
      'no_supervisors_found_for_filter': 'لم يتم العثور على مشرفين {filter}',
      'show_all_supervisors': 'عرض كل المشرفين',

      // Emergency Dashboard
      'emergency_dashboard': 'لوحة تحكم الطوارئ',
      'missing_orphans': 'الأيتام المفقودون',
      'unsupervised_orphans': 'الأيتام غير المشرف عليهم',
      'inactive_supervisors': 'المشرفون غير النشطين',
      'all_clear': 'كل شيء واضح!',
      'all_orphans_safe': 'جميع الأيتام في الحسبان وبأمان',
      'show_all_emergency_cases': 'عرض جميع حالات الطوارئ',

      // Settings Page
      'language': 'لغة',
      'theme': 'سمة',
      'light': 'فاتح',
      'dark': 'داكن',
      'data_management': 'إدارة البيانات',
      'backup_restore': 'النسخ الاحتياطي والاستعادة',
      'clear_all_data': 'مسح كافة البيانات',
      'system': 'النظام',
      'api_connection_status': 'حالة اتصال API',
      'about': 'حول',
      'help_support': 'المساعدة والدعم',
      'privacy_policy': 'سياسة الخصوصية',
      // Subtitles
      'manage_backups': 'إدارة النسخ الاحتياطية لبياناتك',
      'delete_all_data': 'حذف جميع البيانات نهائيًا (يتم إنشاء نسخة احتياطية أولاً)',
      'view_server_status': 'عرض حالة الخادم والنفق',
      'app_version': 'Orphan HQ v1.0.0',
      'get_help': 'الحصول على المساعدة والاتصال بالدعم',
      'read_privacy_policy': 'اقرأ سياسة الخصوصية الخاصة بنا',
      'notifications': 'إشعارات',
      'notifications_subtitle': 'مكين (لم تنفذ بعد)',
    },
  };

  String translate(String key, {Map<String, String> params = const {}}) {
    String? translation = _localizedValues[locale.languageCode]?[key];
    if (translation == null) {
      return key;
    }
    params.forEach((paramKey, paramValue) {
      translation = translation!.replaceAll('{$paramKey}', paramValue);
    });
    return translation!;
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