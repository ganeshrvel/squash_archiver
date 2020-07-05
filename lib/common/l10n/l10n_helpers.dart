import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/l10n/l10n.dart';
import 'package:squash_archiver/features/app/data/models/language_model.dart';

/// find the language code from https://api.flutter.dev/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html
final List<LanguageModel> supportedL10nLanguages = [
  const LanguageModel(countryCode: 'IN', locale: 'en', language: 'English'),
];

final List<String> supportedL10nLocales =
    supportedL10nLanguages.map((language) => language.locale).toList();

String ln(BuildContext context, String key) {
  final value = L10n.of(context).translate(key);

  if (value == null) {
    throw 'No text translation found for $key';
  }

  return value;
}

LanguageModel getDefaultAppLanguage() {
  return supportedL10nLanguages.first;
}
