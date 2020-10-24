// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
BookModel _$BookModelFromJson(Map<String, dynamic> json) {
  return _BookModel.fromJson(json);
}

/// @nodoc
class _$BookModelTearOff {
  const _$BookModelTearOff();

// ignore: unused_element
  _BookModel call(
      {num balance = 0,
      @JsonKey(includeIfNull: false, toJson: _idToJson) String id,
      String name,
      Map<String, String> roles}) {
    return _BookModel(
      balance: balance,
      id: id,
      name: name,
      roles: roles,
    );
  }

// ignore: unused_element
  BookModel fromJson(Map<String, Object> json) {
    return BookModel.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $BookModel = _$BookModelTearOff();

/// @nodoc
mixin _$BookModel {
  num get balance;
  @JsonKey(includeIfNull: false, toJson: _idToJson)
  String get id;
  String get name;
  Map<String, String> get roles;

  Map<String, dynamic> toJson();
  $BookModelCopyWith<BookModel> get copyWith;
}

/// @nodoc
abstract class $BookModelCopyWith<$Res> {
  factory $BookModelCopyWith(BookModel value, $Res Function(BookModel) then) =
      _$BookModelCopyWithImpl<$Res>;
  $Res call(
      {num balance,
      @JsonKey(includeIfNull: false, toJson: _idToJson) String id,
      String name,
      Map<String, String> roles});
}

/// @nodoc
class _$BookModelCopyWithImpl<$Res> implements $BookModelCopyWith<$Res> {
  _$BookModelCopyWithImpl(this._value, this._then);

  final BookModel _value;
  // ignore: unused_field
  final $Res Function(BookModel) _then;

  @override
  $Res call({
    Object balance = freezed,
    Object id = freezed,
    Object name = freezed,
    Object roles = freezed,
  }) {
    return _then(_value.copyWith(
      balance: balance == freezed ? _value.balance : balance as num,
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
      roles: roles == freezed ? _value.roles : roles as Map<String, String>,
    ));
  }
}

/// @nodoc
abstract class _$BookModelCopyWith<$Res> implements $BookModelCopyWith<$Res> {
  factory _$BookModelCopyWith(
          _BookModel value, $Res Function(_BookModel) then) =
      __$BookModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {num balance,
      @JsonKey(includeIfNull: false, toJson: _idToJson) String id,
      String name,
      Map<String, String> roles});
}

/// @nodoc
class __$BookModelCopyWithImpl<$Res> extends _$BookModelCopyWithImpl<$Res>
    implements _$BookModelCopyWith<$Res> {
  __$BookModelCopyWithImpl(_BookModel _value, $Res Function(_BookModel) _then)
      : super(_value, (v) => _then(v as _BookModel));

  @override
  _BookModel get _value => super._value as _BookModel;

  @override
  $Res call({
    Object balance = freezed,
    Object id = freezed,
    Object name = freezed,
    Object roles = freezed,
  }) {
    return _then(_BookModel(
      balance: balance == freezed ? _value.balance : balance as num,
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
      roles: roles == freezed ? _value.roles : roles as Map<String, String>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_BookModel implements _BookModel {
  _$_BookModel(
      {this.balance = 0,
      @JsonKey(includeIfNull: false, toJson: _idToJson) this.id,
      this.name,
      this.roles})
      : assert(balance != null);

  factory _$_BookModel.fromJson(Map<String, dynamic> json) =>
      _$_$_BookModelFromJson(json);

  @JsonKey(defaultValue: 0)
  @override
  final num balance;
  @override
  @JsonKey(includeIfNull: false, toJson: _idToJson)
  final String id;
  @override
  final String name;
  @override
  final Map<String, String> roles;

  @override
  String toString() {
    return 'BookModel(balance: $balance, id: $id, name: $name, roles: $roles)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BookModel &&
            (identical(other.balance, balance) ||
                const DeepCollectionEquality()
                    .equals(other.balance, balance)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.roles, roles) ||
                const DeepCollectionEquality().equals(other.roles, roles)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(balance) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(roles);

  @override
  _$BookModelCopyWith<_BookModel> get copyWith =>
      __$BookModelCopyWithImpl<_BookModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_BookModelToJson(this);
  }
}

abstract class _BookModel implements BookModel {
  factory _BookModel(
      {num balance,
      @JsonKey(includeIfNull: false, toJson: _idToJson) String id,
      String name,
      Map<String, String> roles}) = _$_BookModel;

  factory _BookModel.fromJson(Map<String, dynamic> json) =
      _$_BookModel.fromJson;

  @override
  num get balance;
  @override
  @JsonKey(includeIfNull: false, toJson: _idToJson)
  String get id;
  @override
  String get name;
  @override
  Map<String, String> get roles;
  @override
  _$BookModelCopyWith<_BookModel> get copyWith;
}
