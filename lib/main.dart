
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'services/book_api_service.dart';
import 'repositories/book_repository.dart';
import 'repositories/saved_book_repository.dart';
import 'providers/book_provider.dart';
import 'providers/saved_book_provider.dart';
import 'utils/supabase_config.dart';

// Import PDF
import 'pdf/repositories/pdf_library_repository.dart';
import 'pdf/providers/pdf_library_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabasePublishableKey,
  );

  // Membuat sesi pengguna anonim jika belum ada sesi.
  final supabase = Supabase.instance.client;

  if (supabase.auth.currentUser == null) {
    await supabase.auth.signInAnonymously();
  }

  runApp(const BacaYukApp());
}

class BacaYukApp extends StatelessWidget {
  const BacaYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider untuk katalog buku dari REST API.
        ChangeNotifierProvider(
          create: (_) => BookProvider(
            repository: BookRepository(
              apiService: BookApiService(),
            ),
          ),
        ),

        // Provider untuk koleksi buku di Supabase.
        ChangeNotifierProvider(
          create: (_) => SavedBookProvider(
            repository: SavedBookRepository(
              supabase: Supabase.instance.client,
            ),
          ),
        ),

        // Provider untuk perpustakaan PDF.
        ChangeNotifierProvider(
          create: (_) => PdfLibraryProvider(
            repository: PdfLibraryRepository(),
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
