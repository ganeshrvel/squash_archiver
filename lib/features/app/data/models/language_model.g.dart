// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageModel _$LanguageModelFromJson(Map<String, dynamic> json) {
  return LanguageModel(
    countryCode: json['countryCode'] as String,
    locale: json['locale'] as String,
    language: json['language'] as String,
    dictionary: Map<String, String>.from(json['dictionary'] as Map),
  );
}

Map<String, dynamic> _$LanguageModelToJson(LanguageModel instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'locale': instance.locale,
      'language': instance.language,
      'dictionary': instance.dictionary,
    };
