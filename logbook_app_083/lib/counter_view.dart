import 'package:flutter/material.dart';
import 'counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});
  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  void _handleReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Reset"),
        content: const Text("Apakah Anda yakin ingin menghapus semua data?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              setState(() {
                _controller.reset();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Data berhasil direset!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text("Ya, Reset", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LogBook: Homework")),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text("Total Hitungan:"),
              Text('${_controller.value}', style: const TextStyle(fontSize: 40)),

              const SizedBox(height: 20),
              const Text("Atur Besaran Step:"),
              
              SizedBox(
                width: 300,
                child: Slider(
                  value: _controller.step.toDouble(),
                  min: 1, max: 10, divisions: 9,
                  label: _controller.step.toString(),
                  onChanged: (v) => setState(() => _controller.setStep(v.toInt())),
                ),
              ),
              Text("Step: ${_controller.step}", style: const TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),
              const Divider(),
              const Text("Riwayat Aktivitas:", style: TextStyle(fontWeight: FontWeight.bold)),
              
              const SizedBox(height: 10),

              if (_controller.history.isEmpty)
                const Text("Belum ada data.")
              else
                ..._controller.history.map((log) {
                  Color cardColor = Colors.white;
                  IconData icon = Icons.info;

                  if (log.contains("Menambah")) {
                    cardColor = Colors.green.shade100;
                    icon = Icons.arrow_upward;
                  } else if (log.contains("Mengurang")) {
                    cardColor = Colors.red.shade100;
                    icon = Icons.arrow_downward;
                  } else if (log.contains("Reset")) {
                    cardColor = Colors.grey.shade200;
                    icon = Icons.refresh;
                  }

                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(icon, size: 20),
                      title: Text(log, style: const TextStyle(fontSize: 14)),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => setState(() => _controller.decrement()),
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),

          const SizedBox(width: 10),

          FloatingActionButton(
            onPressed: _handleReset, 
            backgroundColor: Colors.grey,
            child: const Icon(Icons.refresh),
          ),

          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => setState(() => _controller.increment()),
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}