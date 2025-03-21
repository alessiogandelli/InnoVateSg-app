// questions.dart
import 'dart:convert';

// class QuestionCollection {
//   final List<Question> business;
//   final List<Question> product;
//   final List<Question> process;
//   final List<Question> customer;
//   final List<Question> sustainability;

//   QuestionCollection({
//     required this.business,
//     required this.product,
//     required this.process,
//     required this.customer,
//     required this.sustainability,
//   });

//   factory QuestionCollection.fromJson(Map<String, dynamic> json) {
//     return QuestionCollection(
//       business: List<Question>.from(
//           json['business'].map((x) => Question.fromJson(x))),
//       product: List<Question>.from(
//           json['product'].map((x) => Question.fromJson(x))),
//       process: List<Question>.from(
//           json['process'].map((x) => Question.fromJson(x))),
//       customer: List<Question>.from(
//           json['customer'].map((x) => Question.fromJson(x))),
//       sustainability: List<Question>.from(
//           json['sustainability'].map((x) => Question.fromJson(x))),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'business': business.map((x) => x.toJson()).toList(),
//         'product': product.map((x) => x.toJson()).toList(),
//         'process': process.map((x) => x.toJson()).toList(),
//         'customer': customer.map((x) => x.toJson()).toList(),
//         'sustainability': sustainability.map((x) => x.toJson()).toList(),
//       };
// }

class Question {
  final String question;
  final List<String> answers;

  Question({
    required this.question,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answers: List<String>.from(json['answers']),
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'answers': answers,
      };
}

class AnsweredQuestion {
  final String question;
  final String answer;

  AnsweredQuestion({
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };

  factory AnsweredQuestion.fromJson(Map<String, dynamic> json) {
    return AnsweredQuestion(
      question: json['question'],
      answer: json['answer'],
    );
  }
}