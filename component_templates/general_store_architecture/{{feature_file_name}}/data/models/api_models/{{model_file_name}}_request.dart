import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part '{{model_file_name}}_request.g.dart';

@JsonSerializable(nullable: false)
class {{ModelClassName}}Request extends Equatable {
  final int page;

  const {{ModelClassName}}Request({
    @required this.page,
  });

  Map<String, dynamic> toJson() => _${{ModelClassName}}RequestToJson(this);

  factory {{ModelClassName}}Response.fromJson(Map<String, dynamic> json) =>
  _${{ModelClassName}}ResponseFromJson(json);

  @override
  List<Object> get props => [page];
}
