import 'package:flutter/material.dart';
import 'package:innovate/services/storage_service.dart';
import 'package:innovate/models/onboarding_data.dart';
import 'package:innovate/models/innovation_data.dart';
import 'package:innovate/screens/innovation/innovation_assessment_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  OnboardingData? onboardingData;
  InnovationData? innovationData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final StorageService storageService = StorageService();
    final onboardingResult = await storageService.getOnboardingData();
    final innovationResult = await storageService.getInnovationData();
    
    setState(() {
      onboardingData = onboardingResult;
      innovationData = innovationResult;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Get current innovation level from data or default to 1
    final int currentLevel = 0;
    const int maxLevel = 5;
    final double progressValue = currentLevel / maxLevel;
    
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            
            // Replace simple CircleAvatar with Stack for level indicator
            Stack(
              alignment: Alignment.center,
              children: [
                // Circular progress indicator
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.deepPurple,
                  ),
                ),
                
                // User avatar
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                
                // Level indicator badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      '$currentLevel',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            // Level text indicator
            Text(
              _getLevelTitle(currentLevel),
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              onboardingData?.name ?? 'User Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () async {
              await StorageService().deleteOnboardingData();
              setState(() {
                onboardingData = null;
              });
            }, child: const Text('Reset Onboarding')),
            
            // Company information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.business, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Text(onboardingData?.companyName ?? 'Not specified', 
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.category, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Text('Industry: ${onboardingData?.industries ?? 'Not specified'}', 
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Innovation roadmap or Complete Profile button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Innovation Journey',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  if (innovationData?.businessModel.isEmpty ?? true)
                    _buildCompleteProfileButton(context)
                  else 
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Profile Complete',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            const ListTile(
              leading: Icon(Icons.history),
              title: Text('Chat History'),
            ),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
    );
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
                    builder: (context) => InnovationAssessmentPage(
                      currentData: innovationData,
                    ),
                  ),
                ).then((_) => _loadUserData()); // Reload data when returning
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
}
