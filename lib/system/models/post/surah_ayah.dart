import 'package:flutter/material.dart';

class AcheivementType {
  final SurahAyah? hifd;
  final SurahAyah? quickRev;
  final SurahAyah? majorRev;
  AcheivementType({
    this.hifd,
    this.quickRev,
    this.majorRev,
  });
  factory AcheivementType.fromJson(List<dynamic> jsonList) {
    SurahAyah? hifd;
    SurahAyah? quickRev;
    SurahAyah? majorRev;

    for (var item in jsonList) {
      if (item.containsKey('hifd')) {
        hifd = SurahAyah.fromMap(item['hifd']);
      } else if (item.containsKey('quickRev')) {
        quickRev = SurahAyah.fromMap(item['quickRev']);
      } else if (item.containsKey('majorRev')) {
        majorRev = SurahAyah.fromMap(item['majorRev']);
      }
    }

    return AcheivementType(
      hifd: hifd,
      quickRev: quickRev,
      majorRev: majorRev,
    );
  }
}

class SurahAyah {
  UniqueKey key;
  String? fromSurahName;
  String? toSurahName;
  int? fromAyahNumber;
  int? toAyahNumber;
  String? observation;

  SurahAyah(
      {this.fromSurahName,
      this.toSurahName,
      this.fromAyahNumber,
      this.toAyahNumber,
      this.observation})
      : key = UniqueKey();

  Map<String, dynamic> toMap() => {
        'fromSurahName': fromSurahName,
        'toSurahName': toSurahName,
        'fromAyahNumber': fromAyahNumber,
        'toAyahNumber': toAyahNumber,
        'observation': observation
      };

//[{"key":{}}]
  //convert to json array of objects
  List<Map<String, dynamic>> toJson() {
    return [toMap()];
  }

  //convert from json array of objects to list of maps
  static SurahAyah fromMap(Map<String, dynamic> map) {
    return SurahAyah(
      fromSurahName: map['from_surah'],
      toSurahName: map['to_surah'],
      fromAyahNumber: map['from_ayah'],
      toAyahNumber: map['to_ayah'],
      observation: map['observation'],
    );
  }
}
