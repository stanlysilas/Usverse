import 'package:flutter/material.dart';

class WaitingForPartnerScreen extends StatelessWidget {
  const WaitingForPartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border_rounded, color: Colors.redAccent),

            const SizedBox(height: 12),

            Text(
              'Waiting for your partner',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Ask them to join using your invite code.'),
          ],
        ),
      ),
    );
  }
}
