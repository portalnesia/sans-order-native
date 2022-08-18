
import 'package:get/get.dart';
import 'package:sans_order/lang/en.dart';
import 'package:sans_order/lang/id.dart';

class LocalizationService extends Translations {
  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
    'en': enLang, // lang/en_us.dart
    'id': idLang, // lang/tr_tr.dart
  };
}