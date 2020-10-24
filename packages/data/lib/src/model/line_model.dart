import 'package:freezed_annotation/freezed_annotation.dart';

part 'line_model.freezed.dart';
part 'line_model.g.dart';

@freezed
abstract class LineModel with _$LineModel {
  factory LineModel({
    num amount,
    @JsonKey(includeIfNull: false, toJson: _idToJson) String id,
    String uid,
    DateTime when,
  }) = _LineModel;

  factory LineModel.fromJson(Map<String, dynamic> json) =>
      _$LineModelFromJson(json);
}

String _idToJson(_) => null;
