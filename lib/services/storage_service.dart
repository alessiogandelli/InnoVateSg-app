import 'dart:convert';
import 'dart:io';
import 'package:innovate/models/quesions.dart';
import 'package:innovate/services/api_service.dart';
import 'package:innovate/services/llm_service.dart';
import 'package:innovate/services/stregatto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:innovate/models/onboarding_data.dart';
import 'package:innovate/models/innovation_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _fileName = 'user_data.json';
  static const String _innovationFileName = 'innovation_data.json';
  static const String _questions = 'questions.json';
  static const String _answeredQuestions = 'answered_questions.json';
  
  // API endpoint configuration - replace with your actual endpoint
  // static const String stregattoApiEndpoint = 'https://ai-service-url/';
  // static const String stregattoApiKey = '';
  
  // Get a configured Stregatto provider
  // StregattoProvider getStregattoProvider() {
  //   return StregattoProvider(
  //     apiEndpoint: stregattoApiEndpoint,
  //     apiKey: stregattoApiKey,
  //   );
  // }

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
     final questions = await OpenAIService().generateQuestions(data);
        print('Questions generated: $questions');
    try {
      final file = await _getFile(_fileName);
      await file.writeAsString(jsonEncode(data.toJson()));
      print('Onboarding data saved $data');
      
      // Safely call the OpenAIService method
       
      try {
        await saveQuestions(questions);

      } catch (serviceError) {
        print('Error generating questions: $serviceError');
        // Continue with the flow even if question generation fails
      }
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
  Future<InnovationData?> getInnovationData() async {
    try {
      final file = await _getFile(_innovationFileName);
      
      if (await file.exists()) {
        final data = await file.readAsString();
        print('Innovation data read: $data');
        return InnovationData.fromJson(jsonDecode(data));
      }
      return null;
    } catch (e) {
      print('Error reading innovation data: $e');
      return null;
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

  // Task completion status methods
  Future<void> saveTaskCompletionStatus(Map<String, List<bool>> status) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> jsonMap = {};
    
    status.forEach((category, tasks) {
      jsonMap[category] = tasks;
    });
    
    await prefs.setString('task_completion_status', jsonEncode(jsonMap));
  }
  
  Future<Map<String, List<bool>>?> getTaskCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('task_completion_status');
    
    if (jsonString == null) {
      return null;
    }
    
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final Map<String, List<bool>> result = {};
    
    jsonMap.forEach((category, tasks) {
      if (tasks is List) {
        result[category] = List<bool>.from(tasks);
      }
    });
    
    return result;
  }
  
  Future<void> deleteTaskCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('task_completion_status');
  }


  // save and get questions 
  Future<void> saveQuestions(List<Question> questions) async {
    try {
      final file = await _getFile(_questions);
      await file.writeAsString(jsonEncode(questions.map((q) => q.toJson()).toList()));
      print('Questions saved $questions');
    } catch (e) {
      print('Error saving questions: $e');
    }
  }

  Future<List<Question>> getQuestions() async {
    try {
      final file = await _getFile(_questions);
      
      if (await file.exists()) {
        final data = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((json) => Question.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error reading questions: $e');
      return [];
    }
  }

  Future<List<AnsweredQuestion>> getAnsweredQuestions() async {
    try {
      final file = await _getFile(_answeredQuestions);
      
      if (await file.exists()) {
        final data = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((json) => AnsweredQuestion.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error reading questions: $e');
      return [];
    }
  }

  // Save answered questions
  Future<void> saveAnsweredQuestions(List<AnsweredQuestion> questions) async {
    try {
      final file = await _getFile(_answeredQuestions);
      await file.writeAsString(jsonEncode(questions.map((q) => q.toJson()).toList()));
      print('Answered questions saved $questions');
      OpenAIService().getTrack(questions);
    } catch (e) {
      print('Error saving answered questions: $e');
    }
  }


}
