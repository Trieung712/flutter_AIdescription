import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translator/translator.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserInfoScreen(),
    );
  }
}

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String name = '';
  String email = '';
  String dob = '';
  String profession = '';
  String organization = '';
  String experience = '';
  String additionalDescription = '';
  String? description; // Chuyển biến description thành kiểu String?

  Future<String?> generateDescription(String prompt) async {
    final model =
    GenerativeModel(model: 'gemini-pro', apiKey: dotenv.env['API_KEY']!);

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text != null) {
      return response.text!;
    } else {
      throw Exception('Failed to generate description');
    }
  }
  Future<String?> translateToEnglish(String text) async {
    final translator = GoogleTranslator();
    Translation translation = await translator.translate(text, to: 'en');
    return translation.text;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    dob = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Profession',
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    profession = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Organization',
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    organization = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Experience',
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    experience = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Additional Description',
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    additionalDescription = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('User Info'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Name: $name'),
                            Text('Email: $email'),
                            Text('Date of Birth: $dob'),
                            Text('Profession: $profession'),
                            Text('Organization: $organization'),
                            Text('Experience: $experience'),
                            Text(
                                'Additional Description: ''$additionalDescription'),

                          ],
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Show Info'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    String prompt =
                        'Tôi là một "$profession" với "$experience" kinh nghiệm làm việc ở "$organization".giúp tôi tạo 3 mô tả ngắn gọn về công việc của mình'
                    'mỗi mô tả không quá 15 từ'
                        ; // Câu hỏi để tạo mô tả.
                    String? generatedDescription =
                    await generateDescription(prompt); // Sửa kiểu dữ liệu ở đây

                    setState(() {
                      additionalDescription = generatedDescription ?? '';
                    });

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Generated Description'),
                          content: SingleChildScrollView(
                            // Thêm SingleChildScrollView ở đây
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: generatedDescription),
                                  maxLines: null,
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    String? englishDescription = await translateToEnglish(generatedDescription!);
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('English Description'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(englishDescription ?? ''),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  additionalDescription =
                                                      englishDescription ?? '';
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text('Translate to English'),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  additionalDescription = generatedDescription ?? '';
                                });
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    print('Failed to generate description: $e');
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to generate description.'),
                          actions: <Widget>[
                            ElevatedButton(
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
                },
                child: Text('Create Description'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

