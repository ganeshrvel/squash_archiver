import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part '{{model_file_name}}_response.g.dart';

@JsonSerializable(nullable: true)
class {{ModelClassName}}Response extends Equatable {
  final List<dynamic> posts;

  const {{ModelClassName}}Response({
    @required this.posts,
  });

  factory {{ModelClassName}}Response.fromJson(Map<String, dynamic> json) =>
      _${{ModelClassName}}ResponseFromJson(json);

  Map<String, dynamic> toJson() => _${{ModelClassName}}ResponseToJson(this);

  @override
  List<Object> get props => [posts];
}
