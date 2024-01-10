import 'package:flutter/material.dart';

class ListView2Screen extends StatelessWidget {
  final options = const [
    'Megaman',
    'Metal Gear',
    'Super Smash',
    'Final Fantasy'
  ];
  const ListView2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ListView Tipo 2'),
        ),
        body: ListView.separated(
          itemCount: options.length,
          itemBuilder: (context, i) => ListTile(
            title: Text(options[i]),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () {
              final game = options[i];
              // ignore: avoid_print
              print(game);
            },
          ),
          separatorBuilder: (_, __) => const Divider(),
        ));
  }
}
