import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'api_response_data_model.g.dart';

@JsonSerializable(nullable: true)
class ApiResponseDataModel {
  @JsonKey(nullable: true)
  final dynamic rawError;

  final String error;

  final bool success;

  ApiResponseDataModel({
    this.rawError,
    @required this.error,
    @required this.success,
  });

  factory ApiResponseDataModel.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseDataModelFromJson(json);
}
