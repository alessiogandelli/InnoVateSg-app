import 'package:flutter/material.dart';
import 'package:innovate/models/onboarding_data.dart';
import 'package:innovate/services/storage_service.dart';
import 'package:innovate/screens/onboarding/welcome_screen.dart';
import 'package:innovate/screens/onboarding/info_screen_one.dart';
import 'package:innovate/screens/onboarding/info_screen_two.dart';
import 'package:innovate/screens/onboarding/questions_screen.dart';
import 'package:innovate/screens/onboarding/onboarding_completed_screen.dart';

class OnboardingFlow extends StatefulWidget {
  final VoidCallback onComplete;
  
  const OnboardingFlow({super.key, required this.onComplete});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _storageService = StorageService();
  int _currentStep = 0;
  late OnboardingData _userData;
  
  @override
  void initState() {
    super.initState();
    _userData = OnboardingData.empty();
  }
  
  void _moveToNextScreen() {
    setState(() {
      _currentStep++;
    });
  }
  
  void _saveUserData(OnboardingData data) async {
    setState(() {
      _userData = data;
      _currentStep = 4;
    });
    
    // Save to storage
    await _storageService.saveOnboardingData(data);
  }
  
  void _completeOnboarding() {
    widget.onComplete();
  }
  
  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return WelcomeScreen(onGetStarted: _moveToNextScreen);
      case 1:
        return InfoScreenOne(onNext: _moveToNextScreen);
      case 2:
        return InfoScreenTwo(onNext: _moveToNextScreen);
      case 3:
        return QuestionsScreen(onComplete: _saveUserData);
      case 4:
        return OnboardingCompletedScreen(
          userData: _userData,
          onGetStarted: _completeOnboarding,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
