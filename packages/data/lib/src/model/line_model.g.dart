// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LineModel _$_$_LineModelFromJson(Map<String, dynamic> json) {
  return _$_LineModel(
    amount: json['amount'] as num,
    category: _categoryFromJson(json['category'] as String),
    id: json['id'] as String,
    note: json['note'] as String,
    uid: json['uid'] as String,
    when: json['when'] == null ? null : DateTime.parse(json['when'] as String),
  );
}

Map<String, dynamic> _$_$_LineModelToJson(_$_LineModel instance) {
  final val = <String, dynamic>{
    'amount': instance.amount,
    'category': _categoryToJson(instance.category),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', _idToJson(instance.id));
  val['note'] = instance.note;
  val['uid'] = instance.uid;
  val['when'] = instance.when?.toIso8601String();
  return val;
}
