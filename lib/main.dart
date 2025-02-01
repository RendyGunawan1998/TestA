import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KlikCair',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nController = TextEditingController();
  final TextEditingController kController = TextEditingController();
  final List<Map<String, int>> gems = [];
  String result = "";

  void addGem() {
    setState(() {
      gems.add({"type": gems.length + 1, "weight": 0});
    });
  }

  void _calculate() {
    int k = int.tryParse(kController.text) ?? 0;

    gems.sort((a, b) => a["weight"]!.compareTo(b["weight"]!));

    List<int> selectedGems = [];
    int currentWeight = 0;

    for (var gem in gems) {
      if (currentWeight + gem["weight"]! <= k) {
        selectedGems.add(gem["type"]!);
        currentWeight += gem["weight"]!;
      } else {
        break;
      }
    }

    setState(() {
      result = selectedGems.isEmpty ? "-1" : selectedGems.join(", ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gem Collector')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nController,
              decoration: InputDecoration(labelText: 'Number of Gems (N)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: kController,
              decoration: InputDecoration(labelText: 'Bag Capacity (K)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addGem,
              child: Text('Add Gem'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: gems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Gem #${gems[index]["type"]}'),
                    subtitle: TextField(
                      decoration: InputDecoration(labelText: 'Weight (Wi)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          gems[index]["weight"] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculate,
              child: Text('Calculate'),
            ),
            SizedBox(height: 10),
            Text(
              'Result: $result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
