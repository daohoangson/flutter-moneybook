// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'line_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
LineModel _$LineModelFromJson(Map<String, dynamic> json) {
  return _LineModel.fromJson(json);
}

/// @nodoc
class _$LineModelTearOff {
  const _$LineModelTearOff();

// ignore: unused_element
  _LineModel call(
      {num amount,
      @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
          LineCategory category,
      @JsonKey(includeIfNull: false, toJson: _idToJson)
          String id,
      String note,
      String uid,
      DateTime when}) {
    return _LineModel(
      amount: amount,
      category: category,
      id: id,
      note: note,
      uid: uid,
      when: when,
    );
  }

// ignore: unused_element
  LineModel fromJson(Map<String, Object> json) {
    return LineModel.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $LineModel = _$LineModelTearOff();

/// @nodoc
mixin _$LineModel {
  num get amount;
  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  LineCategory get category;
  @JsonKey(includeIfNull: false, toJson: _idToJson)
  String get id;
  String get note;
  String get uid;
  DateTime get when;

  Map<String, dynamic> toJson();
  $LineModelCopyWith<LineModel> get copyWith;
}

/// @nodoc
abstract class $LineModelCopyWith<$Res> {
  factory $LineModelCopyWith(LineModel value, $Res Function(LineModel) then) =
      _$LineModelCopyWithImpl<$Res>;
  $Res call(
      {num amount,
      @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
          LineCategory category,
      @JsonKey(includeIfNull: false, toJson: _idToJson)
          String id,
      String note,
      String uid,
      DateTime when});
}

/// @nodoc
class _$LineModelCopyWithImpl<$Res> implements $LineModelCopyWith<$Res> {
  _$LineModelCopyWithImpl(this._value, this._then);

  final LineModel _value;
  // ignore: unused_field
  final $Res Function(LineModel) _then;

  @override
  $Res call({
    Object amount = freezed,
    Object category = freezed,
    Object id = freezed,
    Object note = freezed,
    Object uid = freezed,
    Object when = freezed,
  }) {
    return _then(_value.copyWith(
      amount: amount == freezed ? _value.amount : amount as num,
      category:
          category == freezed ? _value.category : category as LineCategory,
      id: id == freezed ? _value.id : id as String,
      note: note == freezed ? _value.note : note as String,
      uid: uid == freezed ? _value.uid : uid as String,
      when: when == freezed ? _value.when : when as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$LineModelCopyWith<$Res> implements $LineModelCopyWith<$Res> {
  factory _$LineModelCopyWith(
          _LineModel value, $Res Function(_LineModel) then) =
      __$LineModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {num amount,
      @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
          LineCategory category,
      @JsonKey(includeIfNull: false, toJson: _idToJson)
          String id,
      String note,
      String uid,
      DateTime when});
}

/// @nodoc
class __$LineModelCopyWithImpl<$Res> extends _$LineModelCopyWithImpl<$Res>
    implements _$LineModelCopyWith<$Res> {
  __$LineModelCopyWithImpl(_LineModel _value, $Res Function(_LineModel) _then)
      : super(_value, (v) => _then(v as _LineModel));

  @override
  _LineModel get _value => super._value as _LineModel;

  @override
  $Res call({
    Object amount = freezed,
    Object category = freezed,
    Object id = freezed,
    Object note = freezed,
    Object uid = freezed,
    Object when = freezed,
  }) {
    return _then(_LineModel(
      amount: amount == freezed ? _value.amount : amount as num,
      category:
          category == freezed ? _value.category : category as LineCategory,
      id: id == freezed ? _value.id : id as String,
      note: note == freezed ? _value.note : note as String,
      uid: uid == freezed ? _value.uid : uid as String,
      when: when == freezed ? _value.when : when as DateTime,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_LineModel implements _LineModel {
  _$_LineModel(
      {this.amount,
      @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
          this.category,
      @JsonKey(includeIfNull: false, toJson: _idToJson)
          this.id,
      this.note,
      this.uid,
      this.when});

  factory _$_LineModel.fromJson(Map<String, dynamic> json) =>
      _$_$_LineModelFromJson(json);

  @override
  final num amount;
  @override
  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  final LineCategory category;
  @override
  @JsonKey(includeIfNull: false, toJson: _idToJson)
  final String id;
  @override
  final String note;
  @override
  final String uid;
  @override
  final DateTime when;

  @override
  String toString() {
    return 'LineModel(amount: $amount, category: $category, id: $id, note: $note, uid: $uid, when: $when)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LineModel &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.category, category) ||
                const DeepCollectionEquality()
                    .equals(other.category, category)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.note, note) ||
                const DeepCollectionEquality().equals(other.note, note)) &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)) &&
            (identical(other.when, when) ||
                const DeepCollectionEquality().equals(other.when, when)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(category) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(note) ^
      const DeepCollectionEquality().hash(uid) ^
      const DeepCollectionEquality().hash(when);

  @override
  _$LineModelCopyWith<_LineModel> get copyWith =>
      __$LineModelCopyWithImpl<_LineModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_LineModelToJson(this);
  }
}

abstract class _LineModel implements LineModel {
  factory _LineModel(
      {num amount,
      @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
          LineCategory category,
      @JsonKey(includeIfNull: false, toJson: _idToJson)
          String id,
      String note,
      String uid,
      DateTime when}) = _$_LineModel;

  factory _LineModel.fromJson(Map<String, dynamic> json) =
      _$_LineModel.fromJson;

  @override
  num get amount;
  @override
  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  LineCategory get category;
  @override
  @JsonKey(includeIfNull: false, toJson: _idToJson)
  String get id;
  @override
  String get note;
  @override
  String get uid;
  @override
  DateTime get when;
  @override
  _$LineModelCopyWith<_LineModel> get copyWith;
}
