import 'package:shared_preferences/shared_preferences.dart';

class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)
  int _step = 1; 
  
  String _username = "guest";
  List<String> _history = [];

  int get value => _counter; // Getter untuk akses data
  int get step => _step;
  List<String> get history => _history;

  void setStep(int value) {_step = value;}

  Future<void> loadData(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter_$_username') ?? 0;
    _history = prefs.getStringList('history_$_username') ?? [];
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter_$_username', _counter);
    await prefs.setStringList('history_$_username', _history);
  }

  void _addHistory(String message) {
    DateTime now = DateTime.now();
    String timestamp = "${now.hour}:${now.minute}:${now.second}";
    
    _history.insert(0, "$message pada $timestamp");

    if (_history.length > 5) {
      _history.removeLast();
    }
    _saveData();
  }

  void increment() {
    _counter += _step;
    _addHistory("User $_username menambah $_step");
    _saveData();
  }

  void decrement() {
    if (_counter > 0) {
      _counter -= _step;
      if (_counter < 0) _counter = 0;
      _addHistory("User $_username mengurang $_step");
      _saveData();
    }
  }

  void reset() {
    _counter = 0;
    _addHistory("Reset Data oleh $_username");
    _saveData();
  }
}