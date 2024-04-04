import 'package:flutter/material.dart';
import 'package:voice_assistance/feature_box.dart';
import 'package:voice_assistance/pallete.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'package:http/http.dart' as http;

class VoiceInputScreen extends StatefulWidget {
  @override
  _VoiceInputScreenState createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';

  String _text1 = 'Good Morning,what task can I do for you?';
  String? _gptText;

  Future<void> sendRequestToGPT(String inputText) async {
    final apiKey = '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';
    final endpoint = 'https://api.openai.com/v1/engines/davinci/completions';

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final body = {
      'prompt': inputText,
      'max_tokens': 50,
      'temperature': 0.7,
    };
    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _gptText = data['choices'][0]['text'].toString();
        _text1 = _gptText ?? _text1;
      });
    } else {
      print('Failed to fetch response: ${response.statusCode}');
      print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool isAvailable = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    if (isAvailable) {
      setState(() {
        _isListening = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allen'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/virtualAssistant.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.borderColor),
                  borderRadius:
                      BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _gptText ?? _text1,
                  style: const TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontFamily: 'Cera Pro'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                top: 10,
                left: 22,
              ),
              child: const Text(
                "Here are a few features",
                style: TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.mainFontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Column(
              children: [
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  headertext: 'ChatGPT',
                  description:
                      'A smarter way to organize and inoformed with ChatGPT',
                ),
                FeatureBox(
                    color: Pallete.secondSuggestionBoxColor,
                    headertext: 'Dall-E',
                    description:
                        'Get inspired and stay creative with your personal assistant powered by Dall-E'),
                FeatureBox(
                    color: Pallete.thirdSuggestionBoxColor,
                    headertext: 'Smart Voice Assistant',
                    description:
                        'Get the best of both world with a voice assistant powered by Dall-E and ChatGPT')
              ],
            ),
            Text(_text),
            //Text(?_gptText),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_isListening) {
            _startListening();
          } else {
            _stopListening();
            await sendRequestToGPT(_text); // Send the _text to ChatGPT
          }
        },
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }

  void _toggleListening() {
    if (!_isListening) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  void _startListening() {
    if (_isListening) return;
    _speech.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }
}
