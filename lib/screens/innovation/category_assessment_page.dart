import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:innovate/models/innovation_data.dart';
import 'package:innovate/services/api_service.dart';
import 'package:innovate/services/storage_service.dart';
import 'package:innovate/utils/innovation/questions_data.dart';

class CategoryAssessmentPage extends StatefulWidget {
  final String category;
  final String title;
  final InnovationData? currentData;

  const CategoryAssessmentPage({
    super.key, 
    required this.category, 
    required this.title, 
    this.currentData,
  });

  @override
  State<CategoryAssessmentPage> createState() => _CategoryAssessmentPageState();
}

class _CategoryAssessmentPageState extends State<CategoryAssessmentPage> {
  late List<Map<String, dynamic>> questions;
  late List<int> answers;
  int currentQuestionIndex = 0;
  bool isCompleted = false;
  
  @override
  void initState() {
    super.initState();
    questions = QuestionsData.getQuestionsForCategory(widget.category);
    answers = List.filled(questions.length, -1);

    // If we have existing data, prefill answers if available
    if (widget.currentData != null) {
      List<Map<String, String>>? categoryAnswers;
      switch (widget.category) {
      case 'businessModel':
        categoryAnswers = widget.currentData!.businessModel;
        break;
      case 'productInnovation':
        categoryAnswers = widget.currentData!.productInnovation;
        break;
      case 'processInnovation':
        categoryAnswers = widget.currentData!.processInnovation;
        break;
      case 'customerExperience':
        categoryAnswers = widget.currentData!.customerExperience;
        break;
      case 'technologyAdoption':
        categoryAnswers = widget.currentData!.technologyAdoption;
        break;
      }

      // Restore previous answers if they exist
      if (categoryAnswers != null && categoryAnswers.isNotEmpty) {
        for (int i = 0; i < answers.length && i < categoryAnswers.length; i++) {
          var answerEntry = categoryAnswers[i];
          if (answerEntry.containsKey('answer') && answerEntry['answer']!.isNotEmpty) {
            // Find index of the answer in options
            String savedAnswer = answerEntry['answer']!;
            List<String> options = questions[i]['options'];
            for (int j = 0; j < options.length; j++) {
              if (options[j] == savedAnswer) {
                answers[i] = j + 1; // convert to 1-based index
                break;
              }
            }
          }
        }
      }
    }
  }

  void answerQuestion(int answer) {
    setState(() {
      answers[currentQuestionIndex] = answer;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        isCompleted = true;
      }
    });
  }

  Future<void> saveAnswers() async {
    // Get current innovation data or create new
    InnovationData data = widget.currentData ?? InnovationData.empty();
    
    // Convert to map with question and answer
    List<Map<String, String>> answerMaps = [];
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == -1) {
        answerMaps.add({
          'question': questions[i]['question'],
          'answer': ""
        });
      } else {
        // Get the selected option (subtracting 1 because our indices are 1-based)
        List<String> options = questions[i]['options'];
        answerMaps.add({
          'question': questions[i]['question'],
          'answer': options[answers[i] - 1]
        });
      }
    }
    
    // Update the specific category with the result
    switch (widget.category) {
      case 'businessModel':
      data = InnovationData(
        businessModel: answerMaps,
        productInnovation: data.productInnovation,
        processInnovation: data.processInnovation,
        customerExperience: data.customerExperience,
        technologyAdoption: data.technologyAdoption,
      );
      break;
      case 'productInnovation':
      data = InnovationData(
        businessModel: data.businessModel,
        productInnovation: answerMaps,
        processInnovation: data.processInnovation,
        customerExperience: data.customerExperience,
        technologyAdoption: data.technologyAdoption,
      );
      break;
      case 'processInnovation':
      data = InnovationData(
        businessModel: data.businessModel,
        productInnovation: data.productInnovation,
        processInnovation: answerMaps,
        customerExperience: data.customerExperience,
        technologyAdoption: data.technologyAdoption,
      );
      break;
      case 'customerExperience':
      data = InnovationData(
        businessModel: data.businessModel,
        productInnovation: data.productInnovation,
        processInnovation: data.processInnovation,
        customerExperience: answerMaps,
        technologyAdoption: data.technologyAdoption,
      );

      break;
      case 'technologyAdoption':
      data = InnovationData(
        businessModel: data.businessModel,
        productInnovation: data.productInnovation,
        processInnovation: data.processInnovation,
        customerExperience: data.customerExperience,
        technologyAdoption: answerMaps,
      );
      break;
    }
   // ApiService().postData(jsonEncode(answerMaps));

    // Save the updated innovation data
    await StorageService().saveInnovationData(data);
    
    if (mounted) {
      Navigator.pop(context); // Return to assessment selection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isCompleted ? _buildCompletionScreen() : _buildQuestionScreen(),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final question = questions[currentQuestionIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / questions.length,
          backgroundColor: Colors.grey[300],
          color: Colors.deepPurple,
        ),
        const SizedBox(height: 16),
        Text(
          'Question ${currentQuestionIndex + 1}/${questions.length}',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          question['question'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ..._buildAnswerOptions(question['options']),
      ],
    );
  }

  List<Widget> _buildAnswerOptions(List<String> options) {
    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ElevatedButton(
          onPressed: () => answerQuestion(index + 1), // Score from 1 to 5
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          child: Text(
            option,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCompletionScreen() {
    print('Assessment completed! $answers');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            'Assessment Completed!',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Thank you for completing this section of your innovation profile.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: saveAnswers,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text('Save and Continue'),
          ),
        ],
      ),
    );
  }
}