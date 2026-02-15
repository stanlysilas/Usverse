import 'package:flutter/material.dart';

class PartnerSetupScreen extends StatefulWidget {
  const PartnerSetupScreen({super.key});

  @override
  State<PartnerSetupScreen> createState() => _PartnerSetupScreenState();
}

class _PartnerSetupScreenState extends State<PartnerSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Login successful, setup partner.')),
    );
  }
}
