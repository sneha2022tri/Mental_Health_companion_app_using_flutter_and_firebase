import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SereneMind',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
      home: EntryPage(),
    );
  }
}

class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        User user = userCredential.user!;
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: 'Smile, it\'s a free therapy',
            ),
          ),
        );
      } catch (e) {

        print(e.toString());

        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE5F0FF),
              Color(0xFFB5C9FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to SereneMind- Your Mental Health Companion',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Take control of your mental well-being',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                Text(
                  getQuote(),
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          // Navigate to login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  String getQuote() {
    final quotes = [
      "'Your mental health is a priority. Your happiness is an essential. Your self-care is a necessity.'",
      "'Don't forget to love yourself.'",
      "'Your mind is a garden. Your thoughts are the seeds. You can grow flowers, or you can grow weeds.'",
      "'Taking care of yourself is productive.'",
      "'Inhale the future, exhale the past.'",
      "You are enough.'",
      "'You don't have to be perfect to be amazing.'",
      "'Your feelings are valid.'",
      "'Be kind to yourself.'",
      "'You are stronger than you know.'",
    ];
    return quotes[Random().nextInt(quotes.length)];
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        User user = userCredential.user!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: 'Smile, it\'s a free therapy',
            ),
          ),
        );
      } catch (e) {

        print(e.toString());

        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE5F0FF),
              Color(0xFFB5C9FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Login to your account',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                Text(
                  getQuote(), // Display a random quote
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          // Navigate to registration page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EntryPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Create a new account',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  String getQuote() {
    final quotes = [
      "'Your mental health is a priority. Your happiness is an essential. Your self-care is a necessity.'",
      "'Don't forget to love yourself.'",
      "'Your mind is a garden. Your thoughts are the seeds. You can grow flowers, or you can grow weeds.'",
      "'Taking care of yourself is productive.'",
      "'Inhale the future, exhale the past.'",
      "You are enough.'",
      "'You don't have to be perfect to be amazing.'",
      "'Your feelings are valid.'",
      "'Be kind to yourself.'",
      "'You are stronger than you know.'",
    ];
    return quotes[Random().nextInt(quotes.length)];
  }
}

class HomePage extends StatelessWidget {
  final String userName;


  const HomePage({required this.userName});

  void _trackMood(BuildContext context) async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodTrackerPage(),
      ),
    );
  }

  void _trackSleep(BuildContext context) async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SleepTrackerPage(),
      ),
    );
  }

  void _openJournal(BuildContext context) async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalPage(),
      ),
    );
  }

  void _startBreathingExercise(BuildContext context) async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreathingExercisePage(),
      ),
    );
  }

  void _startGuidedMeditations(BuildContext context) async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuidedMeditationsPage(),
      ),
    );
  }

  void _handleNewFeature1(BuildContext context) async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaterIntakePage(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SereneMind'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE5F0FF),
              Color(0xFFB5C9FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 32.0),
            Text(
              'Hi,',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TypewriterAnimatedTextKit(
              text: [userName],
              speed: Duration(milliseconds: 100),
              textStyle: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: [
                      OptionCard(
                        title: 'Mood Tracker',
                        icon: Icons.mood,
                        color: Color(0xFF3366FF),
                        onPressed: () {
                          _trackMood(context);
                        },
                      ),
                      OptionCard(
                        title: 'Sleep Tracker',
                        icon: Icons.nightlight_round,
                        color: Color(0xFF33CC66),
                        onPressed: () {
                          _trackSleep(context);
                        },
                      ),
                      OptionCard(
                        title: 'Journal',
                        icon: Icons.book,
                        color: Color(0xFFFF9933),
                        onPressed: () {
                          _openJournal(context);
                        },
                      ),
                      OptionCard(
                        title: 'Breathing Exercise',
                        icon: Icons.healing,
                        color: Color(0xFF00CCFF),
                        onPressed: () {
                          _startBreathingExercise(context);
                        },
                      ),
                      OptionCard(
                        title: 'Guided Meditations',
                        icon: Icons.headset,
                        color: Color(0xFF66CC99),
                        onPressed: () {
                          _startGuidedMeditations(context);
                        },
                      ),
                      OptionCard(
                        title: 'Water Intake',
                        icon: Icons.star,
                        color: Color(0xFFFFC107),
                        onPressed: () {
                          _handleNewFeature1(context);
                        },
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final int? glassesOfWater;
  final int? waterIntakeTarget;

  const OptionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.glassesOfWater,
    this.waterIntakeTarget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48.0,
                color: Colors.white,
              ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              if (glassesOfWater != null && waterIntakeTarget != null) ...[
                SizedBox(height: 8.0),
                Text(
                  'Glasses of Water: $glassesOfWater / Target: $waterIntakeTarget',
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MoodEntry {
  final int moodRating;
  final int energyRating;
  final int motivationRating;
  final String note;
  final DateTime timestamp;

  MoodEntry({
    required this.moodRating,
    required this.energyRating,
    required this.motivationRating,
    required this.note,
    required this.timestamp,
  });
}

class MoodTrackerPage extends StatefulWidget {
  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  int moodRating = 5;
  int energyRating = 5;
  int motivationRating = 5;
  String moodEvaluation = '';
  IconData moodIcon = Icons.sentiment_neutral;
  String moodNote = '';
  List<MoodEntry> moodEntries = [];

  void updateMoodRating(int value) {
    setState(() {
      moodRating = value;
    });
  }

  void updateEnergyRating(int value) {
    setState(() {
      energyRating = value;
    });
  }

  void updateMotivationRating(int value) {
    setState(() {
      motivationRating = value;
    });
  }

  void evaluateMood() {
    int totalRating = moodRating + energyRating + motivationRating;
    double averageRating = totalRating / 3;
    if (averageRating >= 8) {
      moodEvaluation = 'You are in a great mood!';
      moodIcon = Icons.sentiment_very_satisfied;
    } else if (averageRating >= 6) {
      moodEvaluation = 'You are feeling good.';
      moodIcon = Icons.sentiment_satisfied;
    } else if (averageRating >= 4) {
      moodEvaluation = 'You are feeling okay.';
      moodIcon = Icons.sentiment_neutral;
    } else {
      moodEvaluation = 'You might be having a tough time.';
      moodIcon = Icons.sentiment_dissatisfied;
    }
  }

  void saveMoodEntry() {
    MoodEntry entry = MoodEntry(
      moodRating: moodRating,
      energyRating: energyRating,
      motivationRating: motivationRating,
      note: moodNote,
      timestamp: DateTime.now(),
    );
    setState(() {
      moodEntries.add(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/moodd.jpg'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.7),
                    BlendMode.lighten,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.0),
                Text(
                  'How would you rate your mood?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Slider(
                  value: moodRating.toDouble(),
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  onChanged: (value) {
                    updateMoodRating(value.toInt());
                  },
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.shade200,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Your mood rating: $moodRating',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 32.0),
                Text(
                  'How would you rate your energy level?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Slider(
                  value: energyRating.toDouble(),
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  onChanged: (value) {
                    updateEnergyRating(value.toInt());
                  },
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.shade200,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Your energy rating: $energyRating',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 32.0),
                Text(
                  'How would you rate your motivation level?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Slider(
                  value: motivationRating.toDouble(),
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  onChanged: (value) {
                    updateMotivationRating(value.toInt());
                  },
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.shade200,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Your motivation rating: $motivationRating',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 32.0),
                TextField(
                  onChanged: (value) {
                    moodNote = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Add a note about your mood...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    evaluateMood();
                    saveMoodEntry();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Mood Evaluation'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              moodEvaluation,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Icon(
                              moodIcon,
                              size: 72.0,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Evaluate Mood',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Recent Mood Entries',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: moodEntries.length,
                    itemBuilder: (context, index) {
                      MoodEntry entry = moodEntries[index];
                      return Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            'Mood: ${entry.moodRating}, Energy: ${entry.energyRating}, Motivation: ${entry.motivationRating}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          subtitle: entry.note.isNotEmpty
                              ? Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(entry.note),
                          )
                              : null,
                          trailing: Text(
                            '${entry.timestamp.day}/${entry.timestamp.month}/${entry.timestamp.year}',
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SleepTrackerPage extends StatefulWidget {
  @override
  _SleepTrackerPageState createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  int sleepDuration = 8;
  bool sleepQuality = true;
  TimeOfDay sleepReminderTime = TimeOfDay(hour: 22, minute: 0);
  String sleepFeedback = '';

  void updateSleepDuration(int value) {
    setState(() {
      sleepDuration = value;
    });
  }

  void updateSleepQuality(bool value) {
    setState(() {
      sleepQuality = value;
    });
  }

  void updateSleepReminderTime(TimeOfDay value) {
    setState(() {
      sleepReminderTime = value;
    });
  }

  String getSleepFeedback() {
    int idealSleepDuration = 8;
    int deviation = sleepDuration - idealSleepDuration;
    if (deviation < -1) {
      return 'You need more sleep.';
    } else if (deviation > 1) {
      return 'You need less sleep.';
    } else {
      return 'You slept properly.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracker'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How many hours did you sleep?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 16.0),
            Slider(
              value: sleepDuration.toDouble(),
              min: 1.0,
              max: 12.0,
              divisions: 11,
              onChanged: (value) {
                updateSleepDuration(value.toInt());
              },
              activeColor: Colors.indigo,
              inactiveColor: Colors.indigo.shade200,
            ),
            SizedBox(height: 16.0),
            Text(
              'Sleep duration: $sleepDuration hours',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 32.0),
            Text(
              'Did you have a good night\'s sleep?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Poor',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 8.0),
                Switch(
                  value: sleepQuality,
                  onChanged: (value) {
                    updateSleepQuality(value);
                  },
                  activeColor: Colors.indigo,
                  activeTrackColor: Colors.indigo.shade200,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Good',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            Text(
              'Set Sleep Reminder',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Reminder Time: ${sleepReminderTime.format(context)}',
                  style: TextStyle(fontSize: 16.0),
                ),
                IconButton(
                  onPressed: () async {
                    final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: sleepReminderTime,
                    );
                    if (selectedTime != null) {
                      updateSleepReminderTime(selectedTime);
                    }
                  },
                  icon: Icon(Icons.access_time),
                  color: Colors.indigo,
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                String sleepQualityText = sleepQuality ? 'Good' : 'Poor';
                sleepFeedback = getSleepFeedback();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Sleep Summary',
                      style: TextStyle(color: Colors.indigo),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Sleep duration: $sleepDuration hours'),
                        SizedBox(height: 8.0),
                        Text('Sleep quality: $sleepQualityText'),
                        SizedBox(height: 8.0),
                        Text('Sleep feedback: $sleepFeedback'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Save Sleep',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _textEditingController = TextEditingController();
  String mood = '';
  List<String> tags = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void updateMood(String selectedMood) {
    setState(() {
      mood = selectedMood;
    });
  }

  void addTag(String newTag) {
    setState(() {
      tags.add(newTag);
    });
  }

  void removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Write about your day',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _textEditingController,
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'How are you feeling?',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: [
                  MoodOption(
                    mood: '😃',
                    isSelected: mood == '😃',
                    onTap: () {
                      updateMood('😃');
                    },
                  ),
                  MoodOption(
                    mood: '😐',
                    isSelected: mood == '😐',
                    onTap: () {
                      updateMood('😐');
                    },
                  ),
                  MoodOption(
                    mood: '😔',
                    isSelected: mood == '😔',
                    onTap: () {
                      updateMood('😔');
                    },
                  ),
                  MoodOption(
                    mood: '😢',
                    isSelected: mood == '😢',
                    onTap: () {
                      updateMood('😢');
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Tags',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: [
                  for (String tag in tags)
                    TagItem(
                      tag: tag,
                      onRemove: () {
                        removeTag(tag);
                      },
                    ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddTagDialog(
                          onTagAdded: (newTag) {
                            addTag(newTag);
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            'Add Tag',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  String journalText = _textEditingController.text;

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Journal Entry'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Entry: $journalText'),
                          SizedBox(height: 8.0),
                          Text('Mood: $mood'),
                          SizedBox(height: 8.0),
                          Text('Tags: ${tags.join(", ")}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  'Save Entry',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoodOption extends StatelessWidget {
  final String mood;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodOption({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.indigo : Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(
          mood,
          style: TextStyle(
            fontSize: 24.0,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class TagItem extends StatelessWidget {
  final String tag;
  final VoidCallback onRemove;

  const TagItem({
    required this.tag,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 4.0),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.clear,
              color: Colors.white,
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class AddTagDialog extends StatefulWidget {
  final Function(String) onTagAdded;

  const AddTagDialog({required this.onTagAdded});

  @override
  _AddTagDialogState createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Tag'),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(hintText: 'Enter a tag'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String newTag = _textEditingController.text.trim();
            if (newTag.isNotEmpty) {
              widget.onTagAdded(newTag);
              Navigator.pop(context);
            }
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}





class BreathingExercisePage extends StatefulWidget {
  @override
  _BreathingExercisePageState createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _breathingState = 'Breathe In';
  bool _isBreathing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startBreathing() async {
    setState(() {
      _isBreathing = true;
    });
    await _animateImage();
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      _breathingState = 'Hold';
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _breathingState = 'Breathe Out';
    });
    await _animateImage();
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      _breathingState = 'Breathe In';
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isBreathing = false;
    });
  }

  Future<void> _animateImage() async {
    await _animationController.forward();
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breathing Exercise'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Image.asset(
                        'images/lungs.jpg', // Replace with your image file name and extension
                        width: 200.0,
                        height: 200.0,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 32.0),
            Text(
              _breathingState,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _startBreathing();
              },
              child: Text(
                _isBreathing ? 'Breathing...' : 'Start Breathing',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class GuidedMeditationsPage extends StatelessWidget {
  final List<String> meditations = [
    'Morning Bliss',
    'Serenity Waves',
    'Inner Peace',
    'Nature Retreat',
    'Mindful Journey',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guided Meditations'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: meditations.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ListTile(
                title: Text(
                  meditations[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  'Duration: 10 minutes',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                leading: Icon(
                  Icons.play_circle_filled,
                  size: 36.0,
                  color: Colors.indigo,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _showMeditationDetails(context, index);
                  },
                ),
                onTap: () {
                  _startMeditation(context, index);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _startMeditation(BuildContext context, int index) {
  }

  void _showMeditationDetails(BuildContext context, int index) {
    String meditationName = meditations[index];
    String meditationDetails = '';

    switch (index) {
      case 0:
        meditationDetails =
        'Start your day with this refreshing meditation to cultivate a sense of tranquility and positive energy.';
        break;
      case 1:
        meditationDetails =
        'Immerse yourself in the calming sounds of serene waves, allowing your mind to find peace and stillness.';
        break;
      case 2:
        meditationDetails =
        'Explore the depths of your inner being as you connect with a profound sense of calm and harmony.';
        break;
      case 3:
        meditationDetails =
        'Embark on a virtual retreat to the soothing embrace of nature, rejuvenating your senses and finding balance.';
        break;
      case 4:
        meditationDetails =
        'Embark on a mindful journey of self-discovery, cultivating awareness and finding peace in the present moment.';
        break;
      default:
        meditationDetails = 'Meditation details not available.';
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(meditationName),
          content: Text(meditationDetails),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}


class WaterIntakePage extends StatefulWidget {
  @override
  _WaterIntakePageState createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  int glassesOfWater = 0;
  int waterIntakeTarget = 8;

  void increaseWaterIntake() {
    setState(() {
      glassesOfWater++;
      if (glassesOfWater >= waterIntakeTarget) {
        _showTargetReachedDialog();
      }
    });
  }

  void setWaterIntakeTarget(int target) {
    setState(() {
      waterIntakeTarget = target;
    });
  }

  void _showWaterIntakeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Water Intake Target'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setWaterIntakeTarget(int.tryParse(value) ?? waterIntakeTarget);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTargetReachedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Target Reached'),
          content: Text('Congratulations! You have reached your water intake target.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Intake'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_drink,
                      size: 96.0,
                      color: Color(0xFFFFC107),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Glasses of Water',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      '$glassesOfWater',
                      style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Target: $waterIntakeTarget',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: increaseWaterIntake,
              child: Text(
                'Drink Water',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _showWaterIntakeDialog,
              child: Text(
                'Set Target',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
