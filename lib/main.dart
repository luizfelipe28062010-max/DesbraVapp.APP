import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/locais_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://phwlindqzigvfsmlrbdz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBod2xpbmRxemlndmZzbWxyYmR6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3MDQxNDUsImV4cCI6MjA5NTI4MDE0NX0.hzNFj_l-1LbOvLFClZL9YiwiHg94MdlCNRWJcqH1eKQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turismo Batalha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LocaisScreen(),
    );
  }
}