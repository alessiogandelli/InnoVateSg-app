import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:innovate/models/onboarding_data.dart';

class StorageService {
  static const String _fileName = 'user_data.json';

  // Save onboarding data to a JSON file
  Future<void> saveOnboardingData(OnboardingData data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      await file.writeAsString(jsonEncode(data.toJson()));
    } catch (e) {
      print('Error saving onboarding data: $e');
    }
  }

  // Check if onboarding has been completed
  Future<bool> isOnboardingComplete() async {
    try {
      final OnboardingData? data = await getOnboardingData();
      return data?.onboardingComplete ?? false;
    } catch (e) {
      return false;
    }
  }

  // Get onboarding data from the JSON file
  Future<OnboardingData?> getOnboardingData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      
      if (await file.exists()) {
        final data = await file.readAsString();
        return OnboardingData.fromJson(jsonDecode(data));
      }
      return null;
    } catch (e) {
      print('Error reading onboarding data: $e');
      return null;
    }
  }

  // delete onboarding data
  Future<void> deleteOnboardingData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      await file.delete();
    } catch (e) {
      print('Error deleting onboarding data: $e');
    }
  }
}
