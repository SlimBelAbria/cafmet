import 'dart:convert';
import 'package:flutter/services.dart';

class ProgramItem {
  final String time;
  final String title;
  final String speaker;

  ProgramItem({
    required this.time,
    required this.title,
    required this.speaker,
  });

  factory ProgramItem.fromJson(Map<String, dynamic> json) {
    return ProgramItem(
      time: json['time'],
      title: json['title'],
      speaker: json['speaker'],
    );
  }
}

class SessionProgram {
  final String title;
  final String chairman;
  final String location;
  final List<ProgramItem> program;

  SessionProgram({
    required this.title,
    required this.chairman,
    required this.location,
    required this.program,
  });

  factory SessionProgram.fromJson(Map<String, dynamic> json) {
    return SessionProgram(
      title: json['title'],
      chairman: json['chairman'],
      location: json['location'],
      program: (json['program'] as List)
          .map((item) => ProgramItem.fromJson(item))
          .toList(),
    );
  }
}

class ProgramService {
  static Map<String, SessionProgram>? _cachedPrograms;

  static Future<SessionProgram?> getProgram(String key) async {
    // Load if not cached
    if (_cachedPrograms == null) {
      final jsonString = await rootBundle.loadString('assets/session_programs.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _cachedPrograms = jsonMap.map((k, v) => 
        MapEntry(k, SessionProgram.fromJson(v)));
    }

    return _cachedPrograms?[key];
  }
}