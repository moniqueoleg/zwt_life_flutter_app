// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) {
  return Chapter(
      json['title'] as String,
      json['body'] as String,
      json['cpContent'] as String,
      (json['pageOffsets'] as List)
          ?.map((e) => (e as Map<String, dynamic>)?.map(
                (k, e) => MapEntry(k, e as int),
              ))
          ?.toList());
}

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'cpContent': instance.cpContent,
      'pageOffsets': instance.pageOffsets
    };
