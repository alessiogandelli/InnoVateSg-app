import 'package:flutter/material.dart';
import 'package:innovate/services/storage_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Current innovation level (matching level 3 that's active in the roadmap)
    const int currentLevel = 3;
    const int maxLevel = 5;
    final double progressValue = currentLevel / maxLevel;
   // final StorageService storageService = StorageService().getOnboardingData();
    
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
            const Text(
              'Practicing Innovator',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'User Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: StorageService().deleteOnboardingData, child: Text('reset onbaording')),
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
                        children: const [
                          Icon(Icons.business, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text('TechInnovate Solutions', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.category, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text('Industry: Software & Technology', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Innovation roadmap
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
                  _buildRoadmapLevel(
                    context,
                    level: 1,
                    title: 'Novice Innovator',
                    description: 'Starting to explore innovation concepts',
                    isCompleted: true,
                    isActive: false,
                  ),
                  _buildLevelConnector(true),
                  _buildRoadmapLevel(
                    context,
                    level: 2,
                    title: 'Emerging Innovator',
                    description: 'Applying innovation tools to basic problems',
                    isCompleted: true,
                    isActive: false,
                  ),
                  _buildLevelConnector(true),
                  _buildRoadmapLevel(
                    context,
                    level: 3,
                    title: 'Practicing Innovator',
                    description: 'Implementing innovation methodologies',
                    isCompleted: false,
                    isActive: true,
                  ),
                  _buildLevelConnector(false),
                  _buildRoadmapLevel(
                    context,
                    level: 4,
                    title: 'Advanced Innovator',
                    description: 'Creating disruptive innovation strategies',
                    isCompleted: false,
                    isActive: false,
                  ),
                  _buildLevelConnector(false),
                  _buildRoadmapLevel(
                    context,
                    level: 5,
                    title: 'Master Innovator',
                    description: 'Leading transformative innovation initiatives',
                    isCompleted: false,
                    isActive: false,
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
  
  Widget _buildRoadmapLevel(
    BuildContext context, {
    required int level,
    required String title,
    required String description,
    required bool isCompleted,
    required bool isActive,
  }) {
    return Card(
      elevation: isActive ? 4 : 1,
      color: isActive ? Colors.deepPurple.shade50 : null,
      child: InkWell(
        onTap: () {
          // Handle level selection here
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.deepPurple : Colors.grey.shade300,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white)
                      : Text(
                          level.toString(),
                          style: TextStyle(
                            color: isActive ? Colors.deepPurple : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(Icons.star, color: Colors.amber)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelConnector(bool isCompleted) {
    return Container(
      height: 30,
      width: 2,
      margin: const EdgeInsets.only(left: 20),
      color: isCompleted ? Colors.deepPurple : Colors.grey.shade300,
    );
  }
}
