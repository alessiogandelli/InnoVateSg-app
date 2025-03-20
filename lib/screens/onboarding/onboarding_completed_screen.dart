import 'package:flutter/material.dart';
import 'package:innovate/models/onboarding_data.dart';

class OnboardingCompletedScreen extends StatelessWidget {
  final OnboardingData userData;
  final VoidCallback onGetStarted;
  
  const OnboardingCompletedScreen({
    super.key, 
    required this.userData, 
    required this.onGetStarted
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome, ${userData.name}!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your innovation journey is about to begin',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileItem('Company', userData.companyName),
                        const Divider(),
      
                        _buildProfileItem(
                          'Industries', 
                          userData.interests.join(', ')
                        ),
                        if (userData.innovationAttitudes.isNotEmpty) ...[
                          const Divider(),
                          _buildProfileItem(
                            'Innovation Profile',
                            _getInnovationProfileSummary(userData.innovationAttitudes),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32, 
                      vertical: 16
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start Your Journey',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getInnovationProfileSummary(List<String> attitudes) {
    // Count the occurrences of each attitude
    int cluelessCount = attitudes.where((a) => a == 'Clueless').length;
    int motivatedCount = attitudes.where((a) => a == 'Motivated').length;
    int hesitantCount = attitudes.where((a) => a == 'Hesitant').length;
    
    // Determine the dominant attitude
    if (cluelessCount >= motivatedCount && cluelessCount >= hesitantCount) {
      return 'Innovation Explorer';
    } else if (motivatedCount >= cluelessCount && motivatedCount >= hesitantCount) {
      return 'Innovation Champion';
    } else {
      return 'Innovation Pragmatist';
    }
  }
  
  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
