import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Color(0xFFF5F5F5), // Light beige background color
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int score = 0;
  QuizBrain quizBrain = QuizBrain();
  int? selectedOptionIndex;
  int? correctOptionIndex;
  bool isAnswerChecked = false;

  void decision(int selectedIndex) {
    setState(() {
      selectedOptionIndex = selectedIndex;
      correctOptionIndex = quizBrain.getAnswerIndex();
      isAnswerChecked = true;

      if (selectedIndex == correctOptionIndex) {
        score++; // Increment score for a correct answer
      }

      if (quizBrain.isQuizFinished()) {
        Alert(
          context: context,
          title: "FINISHED!!",
          desc: "You scored $score out of ${quizBrain.getTotalQuestions()}",
        ).show();
        quizBrain.reset();
        score = 0; // Reset score for a new quiz session
        selectedOptionIndex = null; // Reset selected option
        correctOptionIndex = null; // Reset correct option
        isAnswerChecked = false; // Reset answer check state
      } else {
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isAnswerChecked = false;
            quizBrain.nextQuestion();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        ...quizBrain.getOptions().asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          Color boxColor = Colors.grey[300]!; // Default background color
          IconData icon = Icons.circle; // Default icon

          if (isAnswerChecked) {
            if (index == selectedOptionIndex) {
              boxColor =
                  index == correctOptionIndex ? Colors.green : Colors.red;
              icon = index == correctOptionIndex ? Icons.check : Icons.close;
            } else if (index == correctOptionIndex) {
              boxColor = Colors.green;
              icon = Icons.check;
            }
          }

          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                color: boxColor,
                child: InkWell(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: Colors.white), // Icon for correctness
                        SizedBox(width: 10),
                        Text(
                          option,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (!isAnswerChecked) {
                      decision(index);
                    }
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class Question {
  String question;
  List<String> options;
  int answerIndex;

  Question(this.question, this.options, this.answerIndex);
}

class QuizBrain {
  int _currentQuestionIndex = 0;

  final List<Question> _questions = [
    Question('Which planet is known as the Red Planet?',
        ['Earth', 'Mars', 'Jupiter', 'Saturn'], 1),
    Question('What is the capital of France?',
        ['Berlin', 'Madrid', 'Paris', 'Rome'], 2),
    Question(
        'Who wrote "Romeo and Juliet"?',
        [
          'Charles Dickens',
          'J.K. Rowling',
          'Mark Twain',
          'William Shakespeare'
        ],
        3),
    Question('Which element has the chemical symbol O?',
        ['Gold', 'Oxygen', 'Silver', 'Iron'], 1),
    Question('What is the largest mammal in the world?',
        ['Elephant', 'Blue Whale', 'Giraffe', 'Shark'], 1),
    Question('Which country is known as the Land of the Rising Sun?',
        ['China', 'India', 'Japan', 'South Korea'], 2),
    Question('What is the hardest natural substance on Earth?',
        ['Gold', 'Iron', 'Diamond', 'Silver'], 2),
    Question(
        'Who painted the Mona Lisa?',
        [
          'Vincent van Gogh',
          'Leonardo da Vinci',
          'Pablo Picasso',
          'Claude Monet'
        ],
        1),
    Question('Which is the smallest continent?',
        ['Africa', 'Australia', 'Antarctica', 'Europe'], 1),
    Question('Which is the longest river in the world?',
        ['Amazon', 'Nile', 'Yangtze', 'Mississippi'], 1),
    Question('Which gas do plants absorb from the atmosphere?',
        ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'], 1),
    Question(
        'Who is known as the Father of Computers?',
        ['Albert Einstein', 'Isaac Newton', 'Charles Babbage', 'Nikola Tesla'],
        2),
    Question('Which organ in the human body is responsible for pumping blood?',
        ['Lungs', 'Brain', 'Heart', 'Liver'], 2),
    Question('What is the chemical formula for water?',
        ['H2O', 'CO2', 'O2', 'N2'], 0),
    Question('Which is the largest ocean on Earth?',
        ['Atlantic', 'Indian', 'Pacific', 'Arctic'], 2),
    Question('Which planet is closest to the Sun?',
        ['Venus', 'Earth', 'Mercury', 'Mars'], 2),
    Question('Which metal is liquid at room temperature?',
        ['Iron', 'Mercury', 'Gold', 'Silver'], 1),
    Question('Which country invented the Olympic Games?',
        ['China', 'Greece', 'Italy', 'USA'], 1),
    Question('What is the capital city of Australia?',
        ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'], 2),
    Question('Which desert is the largest in the world?',
        ['Sahara', 'Gobi', 'Arabian', 'Kalahari'], 0),
  ];

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _currentQuestionIndex = 0;
    }
  }

  bool isQuizFinished() {
    return _currentQuestionIndex >= _questions.length - 1;
  }

  void reset() {
    _currentQuestionIndex = 0;
  }

  String getQuestion() {
    return _questions[_currentQuestionIndex].question;
  }

  List<String> getOptions() {
    return _questions[_currentQuestionIndex].options;
  }

  int getAnswerIndex() {
    return _questions[_currentQuestionIndex].answerIndex;
  }

  int getTotalQuestions() {
    return _questions.length;
  }
}
