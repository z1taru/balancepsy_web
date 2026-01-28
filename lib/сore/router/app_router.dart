// lib/сore/router/app_router.dart

import 'package:balance_psy/web_pages/cabinet/general/unified_profile_page.dart';
import 'package:balance_psy/web_pages/cabinet/user/profile_patient/psy_catalog.dart';
import 'package:flutter/material.dart';
import '../../web_pages/main/home/home_page.dart';
import '../../web_pages/auth/login_page.dart';
import '../../web_pages/auth/register/register_main.dart';
import '../../web_pages/main/about/about_page.dart';
import '../../web_pages/main/psychologists/psychologists_page.dart';
import '../../web_pages/main/psychologists/psychologist_detail.dart';
import '../../web_pages/main/blog/blog_page.dart';
import '../../web_pages/main/blog/article_detail.dart';
import '../../web_pages/services/services_page.dart';
import '../../web_pages/main/contacts/contacts_page.dart';
import '../../web_pages/cabinet/psy/psycho/psycho_home.dart';
import '../../web_pages/cabinet/psy/psycho/psycho_schedule.dart';
import '../../web_pages/cabinet/psy/psycho/psycho_messages.dart';
import '../../web_pages/cabinet/psy/psycho/psycho_reports.dart';
import '../../web_pages/cabinet/user/profile_patient/home_patient.dart';
import '../../web_pages/cabinet/user/profile_patient/blog_patient.dart';
import '../../web_pages/cabinet/user/profile_patient/chat_patient.dart';
import '../../web_pages/cabinet/user/profile_patient/sessions_calendar.dart';
import '../../web_pages/ai_chat/full_chat_screen.dart';

class AppRouter {
  // Публичные роуты
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String about = '/about';
  static const String psychologists = '/psychologists';
  static const String blog = '/blog';
  static const String articleDetail = '/blog/:id';
  static const String services = '/services';
  static const String contacts = '/contacts';

  // Роуты для клиентов (пациентов)
  static const String dashboard = '/dashboard'; // Главная пациента
  static const String profile = '/profile'; // Профиль пациента
  static const String patientArticles = '/patient/articles';
  static const String chatPatient = '/patient/chat';
  static const String contactsPatient = '/patient/contacts';
  static const String sessionsCalendar = '/patient/sessions-calendar';
  static const String diary = '/patient/diary';

  // Роуты для психологов
  static const String psychoDashboard = '/psycho/dashboard';
  static const String psychoSchedule = '/psycho/schedule';
  static const String psychoMessages = '/psycho/messages';
  static const String psychoReports = '/psycho/reports';
  static const String psychoProfile = '/psycho/profile';

  static const String aiChat = '/ai-chat';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Публичные страницы
      case home:
        return NoAnimationMaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return NoAnimationMaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const RegisterMain(),
        );
      case about:
        return NoAnimationMaterialPageRoute(builder: (_) => const AboutPage());
      case psychologists:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const PsychologistsPage(),
        );
      case blog:
        return NoAnimationMaterialPageRoute(builder: (_) => const BlogPage());
      case services:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const ServicesPage(),
        );
      case contacts:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const ContactsPage(),
        );

      // Страницы пациента
      case dashboard:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const HomePatientPage(),
        );
      case profile:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const UnifiedProfilePage(),
        );
      case patientArticles:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const BlogPatientPage(),
        );
      case chatPatient:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const ChatPatientPage(),
        );
      case contactsPatient:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const PsyCatalogPage(),
        );
      case sessionsCalendar:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const SessionsCalendarPage(),
        );

      // Страницы психолога
      case psychoDashboard:
        return NoAnimationMaterialPageRoute(builder: (_) => const PsyHome());
      case psychoSchedule:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const PsychoSchedulePage(),
        );
      case psychoMessages:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const PsychoMessagesPage(),
        );
      case psychoReports:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const PsychoReportsPage(),
        );
      case psychoProfile:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const UnifiedProfilePage(),
        );
      case aiChat:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const FullChatScreen(),
        );

      default:
        // Динамические роуты
        if (settings.name?.startsWith('/psychologists/') == true) {
          final id = settings.name!.split('/').last;
          return NoAnimationMaterialPageRoute(
            builder: (_) => PsychologistDetail(id: id),
          );
        }
        if (settings.name?.startsWith('/blog/') == true &&
            settings.name != blog) {
          final id = settings.name!.split('/').last;
          return NoAnimationMaterialPageRoute(
            builder: (_) => ArticleDetail(id: id),
          );
        }
        return NoAnimationMaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        );
    }
  }

  static Map<String, String> get routes => {
    'Главная': home,
    'О нас': about,
    'Специалисты': psychologists,
    'Услуги': services,
    'Блог': blog,
    'Контакты': contacts,
  };

  static Map<String, String> get patientRoutes => {
    'Главная': dashboard,
    'Профиль': profile,
    'Статьи': patientArticles,
    'Сообщения': chatPatient,
    'Контакты': contactsPatient,
  };

  static Map<String, String> get psychoRoutes => {
    'Панель': psychoDashboard,
    'Расписание': psychoSchedule,
    'Сообщения': psychoMessages,
    'Отчеты': psychoReports,
    'Профиль': psychoProfile,
  };

  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void replaceWith(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  static void navigateWithArguments(
    BuildContext context,
    String routeName,
    Object arguments,
  ) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  // Получить роут в зависимости от роли пользователя
  static String getDashboardRoute(String? role) {
    switch (role) {
      case 'PSYCHOLOGIST':
        return psychoDashboard;
      case 'CLIENT':
        return dashboard;
      case 'ADMIN':
        return psychoDashboard; // Или создайте отдельный дашборд для админа
      default:
        return home;
    }
  }

  // Получить роут профиля в зависимости от роли
  static String getProfileRoute(String? role) {
    switch (role) {
      case 'PSYCHOLOGIST':
        return psychoProfile;
      case 'CLIENT':
        return profile;
      case 'ADMIN':
        return psychoProfile;
      default:
        return home;
    }
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required super.builder,
    super.settings,
    super.maintainState = true,
  });

  @override
  Duration get transitionDuration => Duration.zero;
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Страница не найдена', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.home,
                (route) => false,
              ),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    );
  }
}
