// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BookModel _$_$_BookModelFromJson(Map<String, dynamic> json) {
  return _$_BookModel(
    balance: json['balance'] as num ?? 0,
    id: json['id'] as String,
    name: json['name'] as String,
    roles: (json['roles'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$_$_BookModelToJson(_$_BookModel instance) {
  final val = <String, dynamic>{
    'balance': instance.balance,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', _idToJson(instance.id));
  val['name'] = instance.name;
  val['roles'] = instance.roles;
  return val;
}
