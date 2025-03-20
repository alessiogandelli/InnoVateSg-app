import 'package:flutter/material.dart';
import 'package:innovate/models/innovation_data.dart';
import 'package:innovate/screens/innovation/category_assessment_page.dart';

class InnovationAssessmentPage extends StatelessWidget {
  final InnovationData? currentData;

  const InnovationAssessmentPage({super.key, this.currentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Innovation Assessment'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete Your Innovation Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a category to assess your innovation capabilities. You can complete them in any order and come back later for the rest.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            _buildCategoryCard(
              context,
              title: 'Business Model',
              description: 'How you create, deliver, and capture value',
              icon: Icons.business_center,
              isCompleted: !(currentData?.businessModel.isEmpty ?? true),
              category: 'businessModel',
            ),
            
            _buildCategoryCard(
              context,
              title: 'Product Innovation',
              description: 'Your approach to developing new products and services',
              icon: Icons.lightbulb,
              isCompleted: !(currentData?.productInnovation.isEmpty ?? true),
              category: 'productInnovation',
            ),
            
            _buildCategoryCard(
              context,
              title: 'Process Innovation',
              description: 'How you improve operational efficiency and effectiveness',
              icon: Icons.loop,
              isCompleted: !(currentData?.processInnovation.isEmpty ?? true),
              category: 'processInnovation',
            ),
            
            _buildCategoryCard(
              context,
              title: 'Customer Experience',
              description: 'Your approach to understanding and serving customers',
              icon: Icons.people,
              isCompleted: !(currentData?.customerExperience.isEmpty ?? true),
              category: 'customerExperience',
            ),
            
            _buildCategoryCard(
              context,
              title: 'Technology Adoption',
              description: 'How you leverage new technologies for innovation',
              icon: Icons.devices,
              isCompleted: !(currentData?.technologyAdoption.isEmpty ?? true),
              category: 'technologyAdoption',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required bool isCompleted,
    required String category,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryAssessmentPage(
                category: category,
                title: title,
                currentData: currentData,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.deepPurple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isCompleted)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}