class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)
  int _step = 1; 
  
  List<String> _history = [];

  int get value => _counter; // Getter untuk akses data
  int get step => _step;
  List<String> get history => _history;

  void setStep(int value) {_step = value;}

  void _addHistory(String message) {
    DateTime now = DateTime.now();
    String timestamp = "${now.hour}:${now.minute}:${now.second}";
    
    _history.insert(0, "$message pada $timestamp");

    if (_history.length > 5) {
      _history.removeLast();
    }
  }

  void increment() {
    _counter += _step;
    _addHistory("Menambah $_step");
  }

  void decrement() {
    if (_counter > 0) {
      _counter -= _step;
      if (_counter < 0) _counter = 0;
      _addHistory("Mengurang $_step");
    }
  }

  void reset() {
    _counter = 0;
    _addHistory("Reset Data");
  }
}