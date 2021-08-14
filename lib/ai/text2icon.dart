import 'package:flutter/services.dart';

// Import tflite_flutter
import 'package:tflite_flutter/tflite_flutter.dart';

class Text2Icon {
  final _modelFile = 'model.tflite';
  final _vocabFile = 'vocab.txt';
  final _labelsFile = 'labels.txt';

  // Maximum length of sentence
  final int _sentenceLen = 256;

  final String start = '<START>';
  final String pad = '<PAD>';
  final String unk = '<UNKNOWN>';

  static late Map<String, int> vocab;
  static late List<String> labelList;
  static late Interpreter model;

  static bool loaded = false;

  Future load() async {
    await _loadModel();
    await _loadDictionary();
    await _loadLabels();
    loaded = true;
  }

  Future _loadModel() async {
    model = await Interpreter.fromAsset(_modelFile);
    print('Model loaded successfully');
  }

  Future _loadDictionary() async {
    final v = await rootBundle.loadString('assets/$_vocabFile');
    var _vocab = <String, int>{};
    final vocabList = v.split('\n');
    for (var i = 0; i < vocabList.length; i++) {
      var entry = vocabList[i].trim().split(' ');
      _vocab[entry[0]] = int.parse(entry[1]);
    }
    vocab = _vocab;
    print('Dictionary loaded successfully');
  }

  Future _loadLabels() async {
    final labels = await rootBundle.loadString('assets/$_labelsFile');
    labelList = labels.split('\n');
    print('Labels loaded successfully');
  }

  Future<List<String>> classify(String rawText) async {
    if (!loaded) {
      await load();
    }
    List<List<int>> input = tokenizeInputText(rawText);
    var output =
        List<double>.filled(labelList.length, 0).reshape([1, labelList.length]);
    model.run(input, output);

    List<double> answer = output[0];

    Map<String, double> result = {};

    answer.forEach((element) {
      result[labelList[answer.indexOf(element)]] = element;
    });

    double cvalue = 0;
    List<String> sortedResult = [];

    result.forEach((key, value) {
      if (value > cvalue) {
        sortedResult = [key, ...sortedResult];
        cvalue = value;
      } else {
        sortedResult.add(key);
      }
    });

    return sortedResult;
  }

  List<List<int>> tokenizeInputText(String text) {
    final toks = text.split(' ');
    var vec = List<int>.filled(_sentenceLen, vocab[pad]!);
    var index = 0;
    if (vocab.containsKey(start)) {
      vec[index++] = vocab[start]!;
    }
    for (var tok in toks) {
      if (index > _sentenceLen) {
        break;
      }
      vec[index++] = vocab.containsKey(tok) ? vocab[tok]! : vocab[unk]!;
    }
    return [vec];
  }
}
