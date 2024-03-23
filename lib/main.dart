import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  String generatedDescription = '';
  String answer = ''; // Biến để lưu trữ kết quả từ API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildUserInfoField('Name', name, (value) {
                setState(() {
                  name = value;
                });
              }),
              SizedBox(height: 20),
              _buildUserInfoField('Email', email, (value) {
                setState(() {
                  email = value;
                });
              }),
              SizedBox(height: 20),
              _buildUserInfoField('Date of Birth', dob, (value) {
                setState(() {
                  dob = value;
                });
              }),
              SizedBox(height: 20),
              _buildUserInfoField('Profession', profession, (value) {
                setState(() {
                  profession = value;
                });
              }),
              SizedBox(height: 20),
              _buildUserInfoField('Organization', organization, (value) {
                setState(() {
                  organization = value;
                });
              }),
              SizedBox(height: 20),
              _buildUserInfoField('Experience', experience, (value) {
                setState(() {
                  experience = value;
                });
              }),
              SizedBox(height: 20),
              _buildUserInfoField(
                  'Additional Description', additionalDescription, (value) {
                setState(() {
                  additionalDescription = value;
                });
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _generateDescription('Flutter là gì?');
                },
                child: Text('Generate Description'),
              ),
              SizedBox(height: 20),
              generatedDescription.isEmpty
                  ? Container()
                  : Text(
                'Generated Description: $generatedDescription',
                style: TextStyle(fontWeight: FontWeight.bold),
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
                                'Additional Description: $additionalDescription'),
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
              TextField(
                controller: TextEditingController(text: answer),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoField(String label, String value,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _generateDescription(String prompt) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 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',
    };
    var body = {
      'prompt': prompt,
      'max_tokens': 50,
      'temperature': 0.7,
      'model': 'gpt-3.5-turbo-1106'
    };
    var response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        generatedDescription = responseData['choices'][0]['text'];
        answer = generatedDescription; // Cập nhật giá trị của answer ở đây
      });
    } else {
      print('Failed to connect to OpenAI. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load description');
    }
  }




}