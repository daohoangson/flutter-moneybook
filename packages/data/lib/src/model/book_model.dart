import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
abstract class BookModel with _$BookModel {
  factory BookModel({
    @Default(0) num balance,
    @JsonKey(includeIfNull: false, toJson: _idToJson) String id,
    String name,
    Map<String, String> roles,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);
}

String _idToJson(_) => null;
