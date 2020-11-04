import 'package:freezed_annotation/freezed_annotation.dart';

import 'line_category.dart';

export 'line_category.dart';

part 'line_model.freezed.dart';
part 'line_model.g.dart';

@freezed
abstract class LineModel with _$LineModel {
  factory LineModel({
    num amount,
    @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
        LineCategory category,
    @JsonKey(includeIfNull: false, toJson: _idToJson) String id,
    String note,
    String uid,
    DateTime when,
  }) = _LineModel;

  factory LineModel.fromJson(Map<String, dynamic> json) =>
      _$LineModelFromJson(json);
}

LineCategory _categoryFromJson(String id) {
  for (final category in LineCategory.values) {
    if (category.id == id) {
      return category;
    }
  }

  return null;
}

String _categoryToJson(LineCategory category) => category.id;

String _idToJson(_) => null;
