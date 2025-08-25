import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routing/app_router.dart';
import 'theme/theme.dart';

class TurboDexApp extends StatelessWidget {
  const TurboDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.build(); // Advanced routing system init
    return MaterialApp.router( // App entry point
      title: 'TurboDex', // Metadata
      theme: TurboDexTheme.light( // Personnalized global theme and style
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      routerConfig: router, // Define routing between screen
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}
