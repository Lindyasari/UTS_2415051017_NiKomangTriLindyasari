import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Baris ini wajib ditambahkan jika fungsi main() menggunakan async
  WidgetsFlutterBinding.ensureInitialized();

  // Membuka jembatan koneksi ke database EduSpark
  await Supabase.initialize(
    url: 'https://darubdqdmwiivzfvmdtb.supabase.co',
    // ignore: deprecated_member_use
    anonKey: 'sb_publishable_oPoNPVlu77HdaEHGzF468A_NEv2MBL7',
  );

  runApp(const EduSparkApp());
}

class EduSparkApp extends StatelessWidget {
  const EduSparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSpark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Layar sementara sebelum kita merancang UI di folder screens
      home: const Scaffold(
        body: Center(
          child: Text('Koneksi Supabase Berhasil Siap!'),
        ),
      ),
    );
  }
}