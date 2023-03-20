import 'dart:convert';

import 'package:intl/intl.dart';

class TaskModel {
  bool isDone;
  String description;
  DateTime shouldEndAt;
  DateTime? completedAt;
  bool isSelected;
  TaskModel({
    required this.isDone,
    required this.description,
    required this.shouldEndAt,
    required this.isSelected,
    this.completedAt,
  });

  TaskStatus get taskStatus {
    if (isDone) return TaskStatus.completed;
    if (shouldEndAt.format == DateTime.now().format) return TaskStatus.inDay;
    if (shouldEndAt.isAfter(DateTime.now())) return TaskStatus.pending;
    return TaskStatus.delayed;
  }

  TaskModel copyWith({
    bool? isDone,
    String? description,
    DateTime? shouldEndAt,
    DateTime? completedAt,
    bool? isSelected,
  }) {
    return TaskModel(
      isDone: isDone ?? this.isDone,
      description: description ?? this.description,
      shouldEndAt: shouldEndAt ?? this.shouldEndAt,
      completedAt: completedAt ?? this.completedAt,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isDone': isDone,
      'description': description,
      'shouldEndAt': shouldEndAt.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'isSelected': isSelected,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      isDone: map['isDone'] ?? false,
      description: map['description'] ?? '',
      shouldEndAt: DateTime.fromMillisecondsSinceEpoch(map['shouldEndAt']),
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
          : null,
      isSelected: map['isSelected'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(isDone: $isDone, description: $description, shouldEndAt: $shouldEndAt, completedAt: $completedAt, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.isDone == isDone &&
        other.description == description &&
        other.shouldEndAt == shouldEndAt &&
        other.completedAt == completedAt &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return isDone.hashCode ^
        description.hashCode ^
        shouldEndAt.hashCode ^
        completedAt.hashCode ^
        isSelected.hashCode;
  }
}

enum TaskStatus { completed, delayed, inDay, pending }

extension DateFormatExtension on DateTime {
  String get format => DateFormat('dd/MM/yyyy').format(this);
}
