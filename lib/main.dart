
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'services/book_api_service.dart';
import 'repositories/book_repository.dart';
import 'providers/book_provider.dart';
import 'utils/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
  url: SupabaseConfig.supabaseUrl,
  publishableKey: SupabaseConfig.supabasePublishableKey,
);

  runApp(const BacaYukApp());
}

class BacaYukApp extends StatelessWidget {
  const BacaYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookProvider(
            repository: BookRepository(
              apiService: BookApiService(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BacaYuk',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8F7F3),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF477A65),
          ),
          fontFamily: 'Roboto',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
