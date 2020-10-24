import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
abstract class UserModel with _$UserModel {
  factory UserModel({
    String displayName,
    bool isAnonymous,
    String uid,
  }) = _UserModel;
}
