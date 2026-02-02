import 'package:balance_psy/providers/chat_provider.dart';
import 'package:balance_psy/web_pages/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_colors.dart';
import 'core/router/app_router.dart';
import 'widgets/web_layout.dart'; // ← Импорт WebLayout

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const BalancePsyApp(),
    ),
  );
}

class BalancePsyApp extends StatefulWidget {
  const BalancePsyApp({super.key});

  @override
  State<BalancePsyApp> createState() => _BalancePsyAppState();
}

class _BalancePsyAppState extends State<BalancePsyApp> {
  @override
  void initState() {
    super.initState();
    // Инициализируем UserProvider при запуске
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BalancePsy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        fontFamily: 'Manrope',
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          surface: AppColors.cardBackground,
          error: AppColors.error,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
        ),
      ),
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,

      // ✅ КЛЮЧЕВОЕ ИЗМЕНЕНИЕ: применяем WebLayout глобально
      builder: (context, child) {
        return WebLayout(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
