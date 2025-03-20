import 'dart:convert';
import 'dart:io';
import 'package:innovate/services/api_service.dart';
import 'package:innovate/services/stregatto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:innovate/models/onboarding_data.dart';
import 'package:innovate/models/innovation_data.dart';

class StorageService {
  static const String _fileName = 'user_data.json';
  static const String _innovationFileName = 'innovation_data.json';
  
  // Get the data directory path
  Future<Directory> _getDataDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final dataDir = Directory('${directory.path}');
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }
    return dataDir;
  }

  // Get a file with the given name in the data directory
  Future<File> _getFile(String fileName) async {
    final dataDir = await _getDataDirectory();
    return File('${dataDir.path}/$fileName');
  }

  // Save onboarding data to a JSON file
  Future<void> saveOnboardingData(OnboardingData data) async {
    try {
      final file = await _getFile(_fileName);
      await file.writeAsString(jsonEncode(data.toJson()));
      print('Onboarding data saved $data');
      await ApiService().getQuestions(data.toJson().toString());
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
      final file = await _getFile(_fileName);
      
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
      final file = await _getFile(_fileName);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting onboarding data: $e');
    }
  }

  // Save innovation data to a JSON file
  Future<void> saveInnovationData(InnovationData data) async {
    try {
      final file = await _getFile(_innovationFileName);
      await file.writeAsString(jsonEncode(data.toJson()));
      
    } catch (e) {
      print('Error saving innovation data: $e');
    }
  }

  // Get innovation data from the JSON file
  Future<InnovationData> getInnovationData() async {
    try {
      final file = await _getFile(_innovationFileName);
      
      if (await file.exists()) {
        final data = await file.readAsString();
        print('Innovation data read: $data');
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
      final file = await _getFile(_innovationFileName);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting innovation data: $e');
    }
  }
}
