import 'package:json_annotation/json_annotation.dart';
part 'BooksBean.g.dart';

@JsonSerializable()
class BooksBean {
  @JsonKey(name: "_id")
  String id;
  String cover;
  String site;
  String author;
  String majorCate;
  String minorCate;
  String title;
  String cat;
  String shortIntro;
  bool allowMonthly;
  int banned;
  int latelyFollower;
  dynamic retentionRatio;
  List<String> tags;

  BooksBean(this.tags,this.id, this.title, this.author, this.cover, this.shortIntro,
      this.site, this.majorCate, this.banned, this.latelyFollower,
     this.retentionRatio,this.minorCate,this.allowMonthly,this.cat);

  factory BooksBean.fromJson(Map<String, dynamic> json) =>
      _$BooksBeanFromJson(json);

  Map<String, dynamic> toJson() => _$BooksBeanToJson(this);
}

