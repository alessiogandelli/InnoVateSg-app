import 'package:flutter/material.dart';
import 'package:innovate/models/quesions.dart';
import 'package:innovate/screens/innovation/innovation_profile.dart';
import 'package:innovate/services/storage_service.dart';
import 'package:innovate/models/onboarding_data.dart';
import 'package:innovate/models/innovation_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:innovate/models/tasks.dart';
import 'dart:async'; // Add this import for Timer

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  OnboardingData? onboardingData;
  List<AnsweredQuestion>? innovationData;
  bool isLoading = true;
  Timer? _taskRefreshTimer; // Add timer field
  
  // Add a map to store tasks for each category
  Map<TaskCategory, List<Task>?> categoryTasks = {
    TaskCategory.businessModel: null,
    TaskCategory.productService: null,
    TaskCategory.processOperations: null,
    TaskCategory.customerMarket: null,
    TaskCategory.sustainability: null,
  };
  
  // Value notifier for current tab index
  final ValueNotifier<int> selectedTabNotifier = ValueNotifier<int>(0);
  
  // Task completion tracking
  Map<String, List<bool>> taskCompletionStatus = {
    'businessModel': List.filled(4, false),
    'productInnovation': List.filled(4, false),
    'processInnovation': List.filled(4, false),
    'customerExperience': List.filled(4, false),
    'technologyAdoption': List.filled(4, false),
  };
  
  // Points system
  Map<String, int> categoryPoints = {
    'businessModel': 0,
    'productInnovation': 0,
    'processInnovation': 0,
    'customerExperience': 0,
    'technologyAdoption': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCategoryTasks();
    
    // Set up timer to refresh tasks every 2 seconds
    _taskRefreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _loadCategoryTasks();
    });
  }

  @override
  void dispose() {
    selectedTabNotifier.dispose();
    _taskRefreshTimer?.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  // Load tasks for each category
  Future<void> _loadCategoryTasks() async {
    final StorageService storageService = StorageService();
    
    // Load tasks for each category
    try {
      final businessModelTasks = await storageService.getTasks(TaskCategory.businessModel);
      final productServiceTasks = await storageService.getTasks(TaskCategory.productService);
      final processOperationsTasks = await storageService.getTasks(TaskCategory.processOperations);
      final customerMarketTasks = await storageService.getTasks(TaskCategory.customerMarket);
      final sustainabilityTasks = await storageService.getTasks(TaskCategory.sustainability);
      
      setState(() {
        categoryTasks[TaskCategory.businessModel] = businessModelTasks;
        categoryTasks[TaskCategory.productService] = productServiceTasks;
        categoryTasks[TaskCategory.processOperations] = processOperationsTasks;
        categoryTasks[TaskCategory.customerMarket] = customerMarketTasks;
        categoryTasks[TaskCategory.sustainability] = sustainabilityTasks;
      });
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _loadUserData() async {
    final StorageService storageService = StorageService();
    final onboardingResult = await storageService.getOnboardingData();
    final innovationResult = await storageService.getAnsweredQuestions();
    
    // Load task completion status
    final taskStatus = await storageService.getTaskCompletionStatus();
    if (taskStatus != null) {
      setState(() {
        taskCompletionStatus = taskStatus;
        // Calculate points based on completed tasks
        taskCompletionStatus.forEach((category, tasks) {
          categoryPoints[category] = tasks.where((task) => task).length * 5;
        });
      });
    }
    
    setState(() {
      onboardingData = onboardingResult;
      innovationData = innovationResult;
      isLoading = false;
    });
  }
  
  // Calculate the current innovation level based on total points
  int get currentLevel {
    int totalPoints = categoryPoints.values.fold(0, (sum, points) => sum + points);
    if (totalPoints >= 80) return 5;
    if (totalPoints >= 60) return 4;
    if (totalPoints >= 40) return 3;
    if (totalPoints >= 20) return 2;
    if (totalPoints >= 5) return 1;
    return 0;
  }
  
  // Save task completion status
  Future<void> _saveTaskStatus() async {
    await StorageService().saveTaskCompletionStatus(taskCompletionStatus);
    
    // Recalculate points
    taskCompletionStatus.forEach((category, tasks) {
      categoryPoints[category] = tasks.where((task) => task).length * 5;
    });
    
    setState(() {}); // Refresh UI
  }
  
  // Toggle task completion status
  void _toggleTaskCompletion(String category, int taskIndex) {
    setState(() {
      taskCompletionStatus[category]![taskIndex] = !taskCompletionStatus[category]![taskIndex];
      _saveTaskStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: LoadingTasks());
    }

    const int maxLevel = 5;
    final double progressValue = currentLevel / maxLevel;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // We'll rebuild this when the tab changes
                ValueListenableBuilder<int>(
                  valueListenable: selectedTabNotifier,
                  builder: (context, selectedIndex, child) {
                    return SizedBox(
                      height: 150,
                      width: 150,
                      child: _buildRadarChart(selectedIndex),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                            Flexible(
                            child: Text(
                              _getLevelTitle(currentLevel),
                              style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              '$currentLevel',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: Colors.grey[300],
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Total Points: ${categoryPoints.values.fold(0, (sum, points) => sum + points)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        onboardingData?.name ?? 'User Profile',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.business, color: Colors.deepPurple, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              onboardingData?.companyName ?? 'Not specified',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.category, color: Colors.deepPurple, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Industry: ${onboardingData?.industries ?? 'Not specified'}',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInnovationProfile(context),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await StorageService().deleteOnboardingData();
                await StorageService().deleteInnovationData();
                await StorageService().deleteTaskCompletionStatus();
                setState(() {
                  onboardingData = null;
                  innovationData = null;
                  // Reset task completion status
                  taskCompletionStatus = {
                    'businessModel': List.filled(4, false),
                    'productInnovation': List.filled(4, false),
                    'processInnovation': List.filled(4, false),
                    'customerExperience': List.filled(4, false),
                    'technologyAdoption': List.filled(4, false),
                  };
                  categoryPoints = {
                    'businessModel': 0,
                    'productInnovation': 0,
                    'processInnovation': 0,
                    'customerExperience': 0,
                    'technologyAdoption': 0,
                  };
                });
              },
              child: const Text('Reset All Data'),
            ),
          ],
        ),
      ),
    );
  }
  
Widget _buildRadarChart(int selectedIndex) {
  // Calculate the max value for scaling
  double maxValue = 0;
  categoryPoints.values.forEach((points) {
    if (points > maxValue) maxValue = points.toDouble();
  });
  
  // If max is 0, set to 1 to avoid division by zero
  maxValue = maxValue == 0 ? 1 : maxValue;
  
  // Categories in order
  List<String> categories = [
    'businessModel', 
    'productInnovation', 
    'processInnovation', 
    'customerExperience', 
    'technologyAdoption'
  ];
  
  // Create a single dataset with all points
  List<RadarEntry> entries = [
    RadarEntry(value: categoryPoints['businessModel']!.toDouble() / maxValue +1),
    RadarEntry(value: categoryPoints['productInnovation']!.toDouble() / maxValue+1),
    RadarEntry(value: categoryPoints['processInnovation']!.toDouble() / maxValue+1),
    RadarEntry(value: categoryPoints['customerExperience']!.toDouble() / maxValue+1),
    RadarEntry(value: categoryPoints['technologyAdoption']!.toDouble() / maxValue+1),
  ];
  
  // Define colors for each section
  List<Color> sectionFillColors = List.filled(50, Colors.grey.withOpacity(0.3));
  List<Color> sectionBorderColors = List.filled(50, Colors.grey);
  
  // Highlight the selected section
  sectionFillColors[selectedIndex] = Colors.deepPurple.withOpacity(0.5);
  sectionBorderColors[selectedIndex] = Colors.deepPurple;
  
  return RadarChart(
    RadarChartData(
      radarBorderData: const BorderSide(color: Colors.transparent),
      tickBorderData: const BorderSide(color: Colors.transparent),
      gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.2)),
      radarBackgroundColor: Colors.transparent,
      tickCount: 5,
      radarShape: RadarShape.polygon,
      dataSets: [
        RadarDataSet(
          dataEntries: entries,
          fillColor: Colors.deepPurple.withOpacity(0.2),
          borderColor: Colors.deepPurple.withOpacity(0.5),
          borderWidth: 1,
          entryRadius: 1,
        ),
      ],
     
      titlePositionPercentageOffset: 0.2,
      titleTextStyle: TextStyle(
        color: Colors.deepPurple,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      // Hide ticks text
      ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
    ),
  );
}

  String _getLevelTitle(int level) {
    switch (level) {
      case 1: return 'Novice Innovator';
      case 2: return 'Emerging Innovator';
      case 3: return 'Practicing Innovator';
      case 4: return 'Advanced Innovator';
      case 5: return 'Master Innovator';
      default: return 'Innovator';
    }
  }

  Widget _buildInnovationProfile(BuildContext context) {
    if (innovationData == null || innovationData!.isEmpty) {
      return _buildCompleteProfileButton(context);
    }

    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepPurple,
            labelStyle: TextStyle(fontSize: 10),
            tabs: [
              Tab(icon: Icon(Icons.business), text: 'Business'),
              Tab(icon: Icon(Icons.inventory), text: 'Product'),
              Tab(icon: Icon(Icons.eco), text: 'Sustainability'),
              Tab(icon: Icon(Icons.settings), text: 'Process'),
              Tab(icon: Icon(Icons.people), text: 'Customer'),
            ],
          ),
          Builder(
            builder: (context) {
              // Listen for tab changes and update the ValueNotifier
              TabController? tabController = DefaultTabController.of(context);
              if (tabController != null) {
                tabController.addListener(() {
                  if (!tabController.indexIsChanging) {
                    selectedTabNotifier.value = tabController.index;
                  }
                });
              }
              return SizedBox(
                height: 400, // Adjust height as needed
                child: TabBarView(
                  children: [
                    _buildCategoryContent(
                      context,
                      'Business Model',
                      _hasCategoryData(TaskCategory.businessModel),
                      'businessModel',
                    ),
                    _buildCategoryContent(
                      context,
                      'Product',
                      _hasCategoryData(TaskCategory.productService),
                      'productInnovation',
                    ),
                    _buildCategoryContent(
                      context,
                      'Process',
                      _hasCategoryData(TaskCategory.processOperations),
                      'processInnovation',
                    ),
                    _buildCategoryContent(
                      context,
                      'Customer',
                      _hasCategoryData(TaskCategory.customerMarket),
                      'customerExperience',
                    ),
                    _buildCategoryContent(
                      context,
                      'Sustainability',
                      _hasCategoryData(TaskCategory.sustainability),
                      'technologyAdoption',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper method to check if there is data for a specific category
  bool _hasCategoryData(TaskCategory category) {
    // Check if we have any related answers in innovationData
    if (innovationData == null || innovationData!.isEmpty) {
      return false;
    }
    
    // If we have any tasks for this category, return true
    if (categoryTasks[category] != null && categoryTasks[category]!.isNotEmpty) {
      return true;
    }
    
    // Default to true if we have any innovation data
    return innovationData!.isNotEmpty;
  }

  Widget _buildCategoryContent(
    BuildContext context,
    String label,
    bool hasData,
    String category,
  ) {
    final TaskCategory categoryEnum = _getCategoryEnum(category);
    final List<Task>? tasks = categoryTasks[categoryEnum];
    
    // Get answered questions related to this category if available
    List<AnsweredQuestion> categoryAnswers = [];
    if (innovationData != null && innovationData!.isNotEmpty) {
      // In a real app, you might want to filter answers by category
      // For now, we'll use all answers for each category
      categoryAnswers = innovationData!;
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: hasData
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${categoryPoints[category]} points',
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Show answers summary if available
                if (categoryAnswers.isNotEmpty)
            
                Expanded(
                  child: tasks!.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                     
                        
                          : ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                // Use existing completion status if available, or create new ones
                                if (taskCompletionStatus[category]!.length <= index) {
                                  taskCompletionStatus[category]!.add(false);
                                }
                                final bool isCompleted = taskCompletionStatus[category]![index];
                                
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: CheckboxListTile(
                                    dense: true,
                                    value: isCompleted,
                                    activeColor: Colors.deepPurple,
                                    title: Text(
                                      task.title,
                                      style: TextStyle(
                                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                                        color: isCompleted ? Colors.grey : Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isCompleted ? Colors.grey : Colors.black54,
                                      ),
                                    ),
                                    secondary: const Text(
                                      '+5 pts',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onChanged: (bool? value) {
                                      _toggleTaskCompletion(category, index);
                                    },
                                  ),
                                );
                              },
                            ),
                ),
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InnovationProfile(),
                    ),
                  ).then((_) => _loadUserData());
                },
                child: Text('Add $label Data'),
              ),
            ),
    );
  }

  // Map category string to TaskCategory enum
  TaskCategory _getCategoryEnum(String category) {
    switch (category) {
      case 'businessModel':
        return TaskCategory.businessModel;
      case 'productInnovation':
        return TaskCategory.productService;
      case 'processInnovation':
        return TaskCategory.processOperations;
      case 'customerExperience':
        return TaskCategory.customerMarket;
      case 'technologyAdoption':
        return TaskCategory.sustainability;
      default:
        return TaskCategory.businessModel;
    }
  }

  Widget _buildCompleteProfileButton(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Complete your innovation profile to track your progress',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InnovationProfile(),
                  ),
                ).then((_) => _loadUserData());
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Complete Your Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LoadingTasks extends StatelessWidget {
  const LoadingTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const SizedBox(height: 16),
          Text(
            'Preparing your innovation tasks...',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
