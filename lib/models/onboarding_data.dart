class OnboardingData {
  final String name;
  final String role;
  final List<String> interests;
  final String innovationLevel;
  final bool onboardingComplete;

  OnboardingData({
    required this.name, 
    required this.role, 
    required this.interests, 
    required this.innovationLevel,
    this.onboardingComplete = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'role': role,
    'interests': interests,
    'innovationLevel': innovationLevel,
    'onboardingComplete': onboardingComplete,
  };

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      name: json['name'] as String,
      role: json['role'] as String,
      interests: List<String>.from(json['interests']),
      innovationLevel: json['innovationLevel'] as String,
      onboardingComplete: json['onboardingComplete'] as bool,
    );
  }

  factory OnboardingData.empty() {
    return OnboardingData(
      name: '',
      role: '',
      interests: [],
      innovationLevel: '',
      onboardingComplete: false,
    );
  }
}
