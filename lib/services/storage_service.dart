import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:innovate/models/onboarding_data.dart';
import 'package:innovate/models/innovation_data.dart';

class StorageService {
  static const String _fileName = 'user_data.json';
  static const String _innovationFileName = 'innovation_data.json';

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

  // Save innovation data to a JSON file
  Future<void> saveInnovationData(InnovationData data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_innovationFileName');
      await file.writeAsString(jsonEncode(data.toJson()));
    } catch (e) {
      print('Error saving innovation data: $e');
    }
  }

  // Get innovation data from the JSON file
  Future<InnovationData> getInnovationData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_innovationFileName');
      
      if (await file.exists()) {
        final data = await file.readAsString();
        return InnovationData.fromJson(jsonDecode(data));
      }
      return InnovationData.empty();
    } catch (e) {
      print('Error reading innovation data: $e');
      return InnovationData.empty();
    }
  }

  // Delete innovation data
  Future<void> deleteInnovationData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_innovationFileName');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting innovation data: $e');
    }
  }
}
