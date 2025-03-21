import 'package:flutter/foundation.dart';

enum TaskCategory {
  businessModel,
  productService,
  processOperations,
  customerMarket,
  sustainability,
}

/// Represents a task with potential innovations.
class Task {
  /// Unique identifier for the task.
  final String id;
  
  /// Title of the task.
  final String title;
  
  /// Description of what the task entails.
  final String description;
  
  /// List of potential innovations associated with this task.
  final List<Innovation> potentialInnovations;

  /// Creates a new task instance.
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.potentialInnovations,
  });

  /// Creates a Task from JSON data.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      potentialInnovations: (json['potentialInnovations'] as List)
          .map((innovation) => Innovation.fromJson(innovation))
          .toList(),
    );
  }

  /// Converts Task to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'potentialInnovations': potentialInnovations.map((innovation) => innovation.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, potentialInnovations: $potentialInnovations}';
  }
}

/// Represents an innovation that can be applied to a task.
class Innovation {
  /// Unique identifier for the innovation.
  final String id;
  
  /// Title of the innovation.
  final String title;
  
  /// Detailed description of the innovation.
  final String description;
  
  /// Level of impact this innovation might have (e.g., "High", "Medium", "Low").
  final String impactLevel;
  
  /// Estimated effort required to implement this innovation.
  final String effortRequired;
  
  /// Potential benefits of implementing this innovation.
  final List<String> benefits;

  /// Creates a new innovation instance.
  Innovation({
    required this.id,
    required this.title,
    required this.description,
    required this.impactLevel,
    required this.effortRequired,
    required this.benefits,
  });

  /// Creates an Innovation from JSON data.
  factory Innovation.fromJson(Map<String, dynamic> json) {
    return Innovation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      impactLevel: json['impactLevel'],
      effortRequired: json['effortRequired'],
      benefits: List<String>.from(json['benefits']),
    );
  }

  /// Converts Innovation to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'impactLevel': impactLevel,
      'effortRequired': effortRequired,
      'benefits': benefits,
    };
  }
}