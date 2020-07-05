// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponseDataModel _$ApiResponseDataModelFromJson(Map<String, dynamic> json) {
  return ApiResponseDataModel(
    rawError: json['rawError'],
    error: json['error'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$ApiResponseDataModelToJson(
        ApiResponseDataModel instance) =>
    <String, dynamic>{
      'rawError': instance.rawError,
      'error': instance.error,
      'success': instance.success,
    };
