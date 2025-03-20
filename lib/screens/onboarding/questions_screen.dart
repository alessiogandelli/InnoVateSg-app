import 'package:flutter/material.dart';
import 'package:innovate/models/onboarding_data.dart';

class QuestionsScreen extends StatefulWidget {
  final Function(OnboardingData) onComplete;
  
  const QuestionsScreen({super.key, required this.onComplete});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 6; // Updated to match the actual number of pages
  
  String _name = '';
  String _role = '';
  List<String> _selectedInterests = [];
  String _innovationLevel = '';
  String _companyName = '';
  List<String> _selectedIndustries = [];
  
  // New variables for innovation attitude questions
  String? _innovationApproach;
  String? _decisionMakingStyle;
  String? _riskPerspective;
  
  final List<String> _availableInterests = [
    'Mechanical', 'Food', 'Healthcare', 'Finance', 'Education', 'Retail',
    'Transportation', 'Energy', 'Agriculture', 'Construction', 
  ];
  

  
  // Map for storing attitude question options and their corresponding categories
  final Map<String, Map<String, String>> _attitudeQuestions = {
    'approach': {
      "We're doing fine as we are - we implement changes when suppliers or clients suggest them.": "Clueless",
      "I know innovation is crucial, but I want to ensure we invest in the right areas for maximum impact.": "Motivated",
      "I'm interested in innovation, but I need to be certain about the returns before making significant changes.": "Hesitant"
    },
    'decisionMaking': {
      "I rely on recommendations from suppliers and trusted business partners.": "Clueless",
      "I actively research emerging trends and consult multiple sources before deciding.": "Motivated",
      "I carefully analyze the risks and benefits, prioritizing solutions with proven track records.": "Hesitant"
    },
    'riskPerspective': {
      "I don't see many reasons to change our current approach.": "Clueless",
      "Investing in the wrong direction and wasting valuable resources.": "Motivated",
      "Implementing changes that might jeopardize our financial stability.": "Hesitant"
    }
  };
  
  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
  }
  
  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
  }
  
  void _completeOnboarding() {
    // Create a list of attitude results
    List<String> attitudes = [];
    
    if (_innovationApproach != null) {
      attitudes.add(_attitudeQuestions['approach']![_innovationApproach]!);
    }
    
    if (_decisionMakingStyle != null) {
      attitudes.add(_attitudeQuestions['decisionMaking']![_decisionMakingStyle]!);
    }
    
    if (_riskPerspective != null) {
      attitudes.add(_attitudeQuestions['riskPerspective']![_riskPerspective]!);
    }
    
    final data = OnboardingData(
      name: _name,
      role: _role,
      companyName: _companyName,
      industries: _selectedInterests,
      interests: _selectedInterests,
      innovationLevel: _innovationLevel,
      innovationAttitudes: attitudes,
      onboardingComplete: true,
    );
    widget.onComplete(data);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / _totalPages,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              
              // Question pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildNameQuestion(),
                    _buildCompanyNameQuestion(),
                    _buildInterestsQuestion(),
                   // _buildInnovationLevelQuestion(),
                    // New attitude questions
                    _buildInnovationApproachQuestion(),
                    _buildDecisionMakingStyleQuestion(),
                    _buildRiskPerspectiveQuestion(),
                  ],
                ),
              ),
              
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentPage > 0
                        ? TextButton(
                            onPressed: _previousPage,
                            child: const Text('Back'),
                          )
                        : const SizedBox(width: 80),
                    ElevatedButton(
                      onPressed: _currentPage == _totalPages - 1
                          ? _completeOnboarding
                          : _canMoveToNextPage() ? _nextPage : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32, 
                          vertical: 16
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1 ? 'Complete' : 'Next',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  bool _canMoveToNextPage() {
    switch (_currentPage) {
      case 0: return _name.isNotEmpty;
      case 1: return _companyName.isNotEmpty;
      case 2: return _selectedInterests.isNotEmpty;
      //case 3: return _innovationLevel.isNotEmpty;
      case 3: return _innovationApproach != null;
      case 4: return _decisionMakingStyle != null;
      case 5: return _riskPerspective != null;
      default: return false;
    }
  }
  
  Widget _buildNameQuestion() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your name?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We'll use this to personalize your experience",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

    Widget _buildCompanyNameQuestion() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your company name?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We'll use this to personalize your experience",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (value) {
              setState(() {
                _companyName = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter your company name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRoleQuestion() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your role?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tell us what you do",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (value) {
              setState(() {
                _role = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'e.g. Product Manager, Designer, Entrepreneur',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInterestsQuestion() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What industries areas interest you?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Select all that apply",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _availableInterests.length,
              itemBuilder: (context, index) {
                final interest = _availableInterests[index];
                final isSelected = _selectedInterests.contains(interest);
                
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(interest);
                      } else {
                        _selectedInterests.add(interest);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          interest,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black87,
                            fontWeight: isSelected 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget _buildInnovationLevelQuestion() {
  //   return Padding(
  //     padding: const EdgeInsets.all(24.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "What's your innovation experience level?",
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         const Text(
  //           "This helps us tailor content to your needs",
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: Colors.grey,
  //           ),
  //         ),
  //         const SizedBox(height: 24),
  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: _innovationLevels.length,
  //             itemBuilder: (context, index) {
  //               final level = _innovationLevels[index];
  //               final isSelected = _innovationLevel == level;
                
  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 12.0),
  //                 child: InkWell(
  //                   onTap: () {
  //                     setState(() {
  //                       _innovationLevel = level;
  //                     });
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                       color: isSelected 
  //                           ? Theme.of(context).colorScheme.primary.withOpacity(0.1) 
  //                           : Colors.white,
  //                       borderRadius: BorderRadius.circular(10),
  //                       border: Border.all(
  //                         color: isSelected
  //                             ? Theme.of(context).colorScheme.primary
  //                             : Colors.grey.shade300,
  //                         width: 2,
  //                       ),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Icon(
  //                           isSelected 
  //                               ? Icons.check_circle 
  //                               : Icons.circle_outlined,
  //                           color: isSelected
  //                               ? Theme.of(context).colorScheme.primary
  //                               : Colors.grey,
  //                         ),
  //                         const SizedBox(width: 16),
  //                         Expanded(
  //                           child: Text(
  //                             level,
  //                             style: TextStyle(
  //                               fontSize: 18,
  //                               fontWeight: isSelected 
  //                                   ? FontWeight.bold 
  //                                   : FontWeight.normal,
  //                               color: isSelected
  //                                   ? Theme.of(context).colorScheme.primary
  //                                   : Colors.black87,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  
  // New question builders for innovation attitudes
  Widget _buildInnovationApproachQuestion() {
    return _buildAttitudeQuestion(
      title: "Which statement best describes your approach to innovation in your business?",
      subtitle: "Select the answer that aligns most with your current perspective",
      options: _attitudeQuestions['approach']!.keys.toList(),
      selectedOption: _innovationApproach,
      onSelected: (value) {
        setState(() {
          _innovationApproach = value;
        });
      },
    );
  }
  
  Widget _buildDecisionMakingStyleQuestion() {
    return _buildAttitudeQuestion(
      title: "When considering new technologies or processes for your business, how do you typically make decisions?",
      subtitle: "Select the option that best matches your approach",
      options: _attitudeQuestions['decisionMaking']!.keys.toList(),
      selectedOption: _decisionMakingStyle,
      onSelected: (value) {
        setState(() {
          _decisionMakingStyle = value;
        });
      },
    );
  }
  
  Widget _buildRiskPerspectiveQuestion() {
    return _buildAttitudeQuestion(
      title: "What's your biggest concern when it comes to making changes in your business?",
      subtitle: "Select the option that reflects your primary concern",
      options: _attitudeQuestions['riskPerspective']!.keys.toList(),
      selectedOption: _riskPerspective,
      onSelected: (value) {
        setState(() {
          _riskPerspective = value;
        });
      },
    );
  }
  
  // Helper method for building attitude questions with the same layout
  Widget _buildAttitudeQuestion({
    required String title,
    required String subtitle,
    required List<String> options,
    required String? selectedOption,
    required Function(String) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selectedOption == option;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Icon(
                              isSelected 
                                  ? Icons.check_circle 
                                  : Icons.circle_outlined,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected 
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
