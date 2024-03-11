// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Survey {
  String question;
  List<int> selectionIndex;
  List<String> options;
  List<double> emmissions;
  bool multiChoice;
  Survey({
    required this.question,
    required this.selectionIndex,
    required this.options,
    required this.emmissions,
    required this.multiChoice,
  });

  Survey copyWith({
    String? question,
    List<int>? selectionIndex,
    List<String>? options,
    List<double>? emmissions,
    bool? multiChoice,
  }) {
    return Survey(
      question: question ?? this.question,
      selectionIndex: selectionIndex ?? this.selectionIndex,
      options: options ?? this.options,
      emmissions: emmissions ?? this.emmissions,
      multiChoice: multiChoice ?? this.multiChoice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'selectionIndex': selectionIndex,
      'options': options,
      'emmissions': emmissions,
      'multiChoice': multiChoice,
    };
  }

  factory Survey.fromMap(Map<String, dynamic> map) {
    return Survey(
      question: map['question'] as String,
      selectionIndex: List<int>.from((map['selectionIndex'] as List<int>)),
      options: List<String>.from((map['options'] as List<String>)),
      emmissions: List<double>.from((map['emmissions'] as List<double>)),
      multiChoice: map['multiChoice'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Survey.fromJson(String source) =>
      Survey.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Survey(question: $question, selectionIndex: $selectionIndex, options: $options, emmissions: $emmissions, multiChoice: $multiChoice)';
  }

  @override
  bool operator ==(covariant Survey other) {
    if (identical(this, other)) return true;

    return other.question == question &&
        listEquals(other.selectionIndex, selectionIndex) &&
        listEquals(other.options, options) &&
        listEquals(other.emmissions, emmissions) &&
        other.multiChoice == multiChoice;
  }

  @override
  int get hashCode {
    return question.hashCode ^
        selectionIndex.hashCode ^
        options.hashCode ^
        emmissions.hashCode ^
        multiChoice.hashCode;
  }
}
