class InnovationData {
  final String userId;
  final String innovationField;
  final List<String> interests;
  final bool profileComplete;

  InnovationData({
    required this.userId,
    required this.innovationField,
    required this.interests,
    this.profileComplete = false,
  });

  // Convert innovation data to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'innovationField': innovationField,
      'interests': interests,
      'profileComplete': profileComplete,
    };
  }

  // Create innovation data from JSON
  factory InnovationData.fromJson(Map<String, dynamic> json) {
    return InnovationData(
      userId: json['userId'],
      innovationField: json['innovationField'],
      interests: List<String>.from(json['interests']),
      profileComplete: json['profileComplete'] ?? false,
    );
  }
}
