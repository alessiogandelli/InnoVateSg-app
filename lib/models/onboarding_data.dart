class OnboardingData {
  final String? name;
  final String? role;
  final List<String> interests;
  final String innovationLevel;
  final bool onboardingComplete;
  final String companyName;
  final List<String> industries;
  final List<String> innovationAttitudes;

  OnboardingData({
     this.name, 
     this.role, 
    required this.interests, 
    required this.innovationLevel,
    this.onboardingComplete = false,
    required this.companyName,
    required this.industries,
    this.innovationAttitudes = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'role': role,
    'interests': interests,
    'innovationLevel': innovationLevel,
    'onboardingComplete': onboardingComplete,
    'companyName': companyName,
    'industries': industries,
    'innovationAttitudes': innovationAttitudes,
  };

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      name: json['name'] as String,
      role: json['role'] as String,
      interests: List<String>.from(json['interests']),
      innovationLevel: json['innovationLevel'] as String,
      onboardingComplete: json['onboardingComplete'] as bool,
      companyName: json['companyName'] as String,
      industries: List<String>.from(json['industries']),
      innovationAttitudes: json['innovationAttitudes'] != null 
          ? List<String>.from(json['innovationAttitudes']) 
          : const [],
    );
  }

  factory OnboardingData.empty() {
    return OnboardingData(
      name: '',
      role: '',
      interests: [],
      innovationLevel: '',
      onboardingComplete: false,
      companyName: '',
      industries: [],
      innovationAttitudes: [],
    );
  }

  @override
  String toString() {
    return 'OnboardingData{name: $name, role: $role, interests: $interests, innovationLevel: $innovationLevel, onboardingComplete: $onboardingComplete, companyName: $companyName, industries: $industries, innovationAttitudes: $innovationAttitudes}';
  }
}
