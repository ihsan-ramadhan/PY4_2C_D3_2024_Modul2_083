import 'package:flutter/material.dart';
import 'package:logbook_app_083/features/logbook/counter_controller.dart';
import 'package:logbook_app_083/features/onboarding/onboarding_view.dart';

class CounterView extends StatefulWidget {
  final String username;

  const CounterView({super.key, required this.username});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await _controller.loadData(widget.username);
    setState(() {});
  }

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

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin? Data yang belum disimpan mungkin akan hilang."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingView()),
                  (route) => false,
                );
              },
              child: const Text("Ya, Keluar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat Pagi,';
    } else if (hour < 15) {
      return 'Selamat Siang,';
    } else if (hour < 18) {
      return 'Selamat Sore,';
    } else {
      return 'Selamat Malam,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logbook: ${widget.username}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                    ),
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Total Hitungan Anda:"),
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

                  if (log.toLowerCase().contains("menambah")) {
                    cardColor = Colors.green.shade100;
                    icon = Icons.arrow_upward;
                  } else if (log.toLowerCase().contains("mengurang")) {
                    cardColor = Colors.red.shade100;
                    icon = Icons.arrow_downward;
                  } else if (log.toLowerCase().contains("reset")) {
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