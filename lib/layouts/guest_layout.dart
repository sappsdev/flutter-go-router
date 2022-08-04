
import 'package:flutter/material.dart';

class GuestLayout extends StatelessWidget {
  final Widget child;
  const GuestLayout({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Layout'),
      ),
      body: Center(
        child: child,
      ),
    );
    
  }
}