import 'package:flutter/material.dart';
import 'package:fl_components/theme/app_theme.dart';

class CustomCardTyoe1 extends StatelessWidget {
  final String title;
  final String subtitle;

  const CustomCardTyoe1({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.house_outlined,
              color: AppTheme.primary,
            ),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // children: [
              //   TextButton(
              //     onPressed: () {},
              //     child: const Text('Cancelar'),
              //   ),
              //   TextButton(
              //     onPressed: () {},
              //     child: const Text('Ok'),
              //   )
              // ],
            ),
          )
        ],
      ),
    );
  }
}
