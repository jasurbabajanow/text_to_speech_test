import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_to_speech_fb2/consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//asdauysgpdiuqweuh ;ahsdhsdasdhasdahs
//sadasidgptyqgdasdhasd
//asdasdasdiusadasd

class _HomePageState extends State<HomePage> {
  FlutterTts _flutterTts = FlutterTts();
  bool isPlaying = false;
  List<Map> _voices = [];
  Map? _currentVoice;
  int? _currentWordStart, _currentWordEnd;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _flutterTts.getVoices.then((data) {
      try {
        _voices = List<Map>.from(data);
        setState(() {
          _voices =
              _voices.where((_voice) => _voice["name"].contains("ru")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _flutterTts.speak(TTS_INPUT);
        },
        child: Icon(Icons.speaker_phone_outlined),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            speakerSelector(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
                children: <TextSpan>[
                  TextSpan(text: TTS_INPUT.substring(0, _currentWordStart)),
                  if (_currentWordStart != null)
                    TextSpan(
                      text: TTS_INPUT.substring(
                        _currentWordStart!,
                        _currentWordEnd,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.purpleAccent,
                      ),
                    ),
                  if (_currentWordEnd != null)
                    TextSpan(text: TTS_INPUT.substring(_currentWordEnd!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget speakerSelector() {
    return DropdownButton(
      value: _currentVoice,
      items:
          _voices
              .map(
                (_voice) => DropdownMenuItem(
                  value: _voice,
                  child: Text(_voice["name"]),
                ),
              )
              .toList(),
      onChanged: (value) {
        _currentVoice = value;
      },
    );
  }
}
