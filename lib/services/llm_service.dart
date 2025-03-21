// .env
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovate/models/onboarding_data.dart';
import 'package:innovate/models/quesions.dart';
import 'package:innovate/models/tasks.dart';

class OpenAIService {
  final String apiKey = const String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );
  final String baseUrl = 'https://api.openai.com/v1';



  Future<List<Question>> generateQuestions(OnboardingData onboarding) async {
    final String promptQuestions = """
generate 10 questions to assess the level of innovation of the company ${onboarding.companyName}, which operates in the ${onboarding.industries.join(', ')} industry.

The questions must cover the following five categories of innovation:

Business Model Innovation – Evaluate innovation in the business model, monetization strategies, partnerships, or distribution channels.
Product/Service Innovation – Analyze the development of new products/services or the improvement of existing ones.
Process/Operations Innovation – Explore the optimization of internal processes to reduce costs and improve efficiency.
Customer & Market Innovation – Investigate strategies to enhance customer experience and loyalty.
Sustainability Innovation – Assess the company’s commitment to environmental and social sustainability.
Consider the following information about the company's CEO/founder:

Name: ${onboarding.name}
Interests: ${onboarding.interests.join(', ')}
The questions must be relevant to the company’s context and the CEO’s characteristics.

The response must be strictly formatted as the following JSON, only the json, it should start with [ and end with ]:
each question should have 4 possible answers to choose from, the answers should be text, the question should be text, the json should be an array of objects, each object should have a question key and an answers key, the answers key should be an array of strings, the question key should be a string

[{ 'question': 'text', 'answers': ['text']}]
  
  """;


    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
      'model': 'gpt-4o-mini-2024-07-18',
      'messages': [
        {'role': 'user', 'content': promptQuestions}
      ],
      'response_format': {'type': 'json_object'},
      'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
           
      final data = jsonDecode(response.body);
     
      final jsonString = data['choices'][0]['message']['content'];
      
      // Parse the content as either a Map or a List based on what's returned
      final dynamic parsedJson = jsonDecode(jsonString);
      List<dynamic> jsonList;
      
      if (parsedJson is Map) {
        // If response is a Map with a key that contains the list, extract it
        // Assume the map has a field like 'questions' or similar
        // Check for a list field or convert the single item to a list
        jsonList = parsedJson.containsKey('questions') 
            ? List<dynamic>.from(parsedJson['questions'])
            : [parsedJson];
      } else if (parsedJson is List) {
        // If response is already a List
        jsonList = parsedJson;
      } else {
        throw Exception('Unexpected response format: $jsonString');
      }
      
      return jsonList.map((json) => Question.fromJson(json)).toList();
      
    } else {
      throw Exception('Failed to generate response: ${response.body}');
    }
  }

  Future<List<Task>> getTasks(List<AnsweredQuestion> answeredQuestion, String category) async {

    final String promptTasks = """
Generate a JSON array of general innovation tasks that a user can complete in the given category based on the answered question. Each task should have an `id`, `title`, `description`, and a list of `potentialInnovations`. Each innovation should represent an atomic action that helps the user get closer to the goal and should have an `id`, `title`, `description`, `impactLevel` (High, Medium, or Low), `effortRequired` (High, Medium, or Low), and a list of benefits.

Answered Question: {answered question}  
Category: {category}

Ensure the JSON is properly formatted and structured as follows:

[
  {
    "id": "1",
    "title": "Task Title",
    "description": "Task Description",
    "potentialInnovations": [
      {
        "id": "1",
        "title": "Innovation Title",
        "description": "Innovation Description",
        "impactLevel": "High",
        "effortRequired": "Low",
        "benefits": ["Benefit 1", "Benefit 2"]
      }
    ]
  }
]

Generate at least 3 unique tasks that fit the category and align with the answered question.

""";


    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
      'model': 'gpt-4o-mini-2024-07-18',
      'messages': [
        {'role': 'user', 'content': promptTasks}
      ],
      'response_format': {'type': 'json_object'},
      'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
           
      final data = jsonDecode(response.body);
      print('data for $category tasks: $data');
      final jsonString = data['choices'][0]['message']['content'];
      
      // Parse the content as either a Map or a List based on what's returned
      final dynamic parsedJson = jsonDecode(jsonString);
      List<dynamic> jsonList;
      
      if (parsedJson is Map) {
        // If response is a Map with a key that contains the list, extract it
        // Assume the map has a field like 'questions' or similar
        // Check for a list field or convert the single item to a list
        jsonList = parsedJson.containsKey('tasks') 
            ? List<dynamic>.from(parsedJson['tasks'])
            : [parsedJson];
      } else if (parsedJson is List) {
        // If response is already a List
        jsonList = parsedJson;
      } else {
        throw Exception('Unexpected response format: $jsonString');
      }
      
      return jsonList.map((json) => Task.fromJson(json)).toList();
      
    } else {
      throw Exception('Failed to generate response: ${response.body}');
    }

      
    // return [
    //   Task(
    //     id: '1', 
    //     title: 'title', 
    //     description: 'description', 
    //     potentialInnovations: [
    //       Innovation(
    //         id: '1',
    //         title: 'Innovation title',
    //         description: 'Innovation description',
    //         impactLevel: 'High',
    //         effortRequired: 'Low',
    //         benefits: ['Benefit 1', 'Benefit 2']
    //       )
    //     ]
    //   )
    // ];
  }
}
