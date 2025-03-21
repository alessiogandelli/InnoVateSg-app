import 'package:flutter/material.dart';
import 'package:innovate/models/quesions.dart';
import 'package:innovate/services/storage_service.dart';

class InnovationProfile extends StatefulWidget {
  const InnovationProfile({Key? key}) : super(key: key);

  @override
  _InnovationProfileState createState() => _InnovationProfileState();
}

class _InnovationProfileState extends State<InnovationProfile> {
  final StorageService _storageService = StorageService();
  List<Question>? _questions;
  int _currentQuestionIndex = 0;
  final Map<int, String> _answers = {};
  bool _isLoading = true;
  final List<Map<String, String>> _savedResponses = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final questions = await _storageService.getQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
      );
    }
  }

  void _saveAnswer(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
      
      // Save the question-answer pair
      _savedResponses.add({
        'question': _questions![_currentQuestionIndex].question,
        'answer': answer
      });
      
      if (_currentQuestionIndex < (_questions?.length ?? 0) - 1) {
        _currentQuestionIndex++;
      } else {
        // All questions answered, handle completion
        _handleCompletion();
      }
    });
  }

  void _handleCompletion() {
    // Here you can use _savedResponses which contains all question-answer pairs
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All questions answered! Processing your innovation profile...'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Example: Print to console
    print('Saved responses: $_savedResponses');
    
    // Example: Navigate to results page with the responses
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => ResultsPage(responses: _savedResponses)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Innovation Profile'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your innovation journey...'),
                ],
              ),
            )
          : _questions == null || _questions!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('No questions available'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadQuestions,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.05),
                        Colors.white,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Progress indicator
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (_currentQuestionIndex + 1) / (_questions?.length ?? 1),
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Question ${_currentQuestionIndex + 1} of ${_questions?.length}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Question card
                          Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _questions![_currentQuestionIndex].question,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Answer options
                                  ...List.generate(
                                    _questions![_currentQuestionIndex].answers.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _saveAnswer(_questions![_currentQuestionIndex].answers[index]);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            elevation: 2,
                                          ),
                                          child: Text(
                                            _questions![_currentQuestionIndex].answers[index],
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Navigation button
                          if (_currentQuestionIndex > 0)
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _currentQuestionIndex--;
                                });
                              },
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Previous Question'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
