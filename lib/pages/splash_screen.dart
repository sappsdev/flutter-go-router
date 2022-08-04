import 'package:flutter/material.dart';
import 'package:flutter_routes/config/constants.dart';

class SplasScreen extends StatelessWidget {
  const SplasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Screen'),
      ),
      body: const Center(
        child: Text(appName),
      ),
    );
  }
}