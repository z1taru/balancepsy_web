// lib/core/router/app_router.dart

import 'package:balance_psy/web_pages/profile/profile.dart';
import 'package:flutter/material.dart';
import '../../web_pages/home/home_page.dart';
import '../../web_pages/auth/login_page.dart';
import '../../web_pages/auth/register/register_main.dart';
import '../../web_pages/about/about_page.dart';
import '../../web_pages/psychologists/psychologists_page.dart';
import '../../web_pages/psychologists/psychologist_detail.dart';
import '../../web_pages/blog/blog_page.dart';
import '../../web_pages/blog/article_detail.dart';
import '../../web_pages/services/services_page.dart';
import '../../web_pages/contacts/contacts_page.dart';
import '../../web_pages/psycho/psycho_dashboard.dart';
import '../../web_pages/psycho/psycho_schedule.dart';
import '../../web_pages/psycho/psycho_messages.dart';
import '../../web_pages/psycho/psycho_reports.dart';
import '../../web_pages/psycho/psycho_profile.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String about = '/about';
  static const String psychologists = '/psychologists';
  static const String blog = '/blog';
  static const String articleDetail = '/blog/:id';
  static const String services = '/services';
  static const String contacts = '/contacts';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String contactsPatient = '/contacts-patient';
  static const String chatPatient = '/chat-patient';
  static const String patientArticles = '/patient/articles';
  static const String sessionsCalendar = '/sessions-calendar';
  static const String diary = '/diary';
  static const String psychoDashboard = '/psycho/dashboard';
  static const String psychoSchedule = '/psycho/schedule';
  static const String psychoMessages = '/psycho/messages';
  static const String psychoReports = '/psycho/reports';
  static const String psychoProfile = '/psycho/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return NoAnimationMaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return NoAnimationMaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return NoAnimationMaterialPageRoute(builder: (_) => const RegisterMain());
      case about:
        return NoAnimationMaterialPageRoute(builder: (_) => const AboutPage());
      case psychologists:
        return NoAnimationMaterialPageRoute(builder: (_) => const PsychologistsPage());
      case blog:
        return NoAnimationMaterialPageRoute(builder: (_) => const BlogPage());
      case patientArticles:
        return NoAnimationMaterialPageRoute(builder: (_) => const ServicesPage());
      case contacts:
        return NoAnimationMaterialPageRoute(builder: (_) => const ContactsPage());
      case dashboard:
        return NoAnimationMaterialPageRoute(builder: (_) => const ProfilePage());
      case profile:
        return NoAnimationMaterialPageRoute(builder: (_) => const PsychoDashboardPage());
      case psychoSchedule:
        return NoAnimationMaterialPageRoute(builder: (_) => const PsychoSchedulePage());
      case psychoMessages:
        return NoAnimationMaterialPageRoute(builder: (_) => const PsychoMessagesPage());
      case psychoReports:
        return NoAnimationMaterialPageRoute(builder: (_) => const PsychoReportsPage());
      case psychoProfile:
        return NoAnimationMaterialPageRoute(builder: (_) => const PsychoProfilePage());

      default:
        if (settings.name?.startsWith('/psychologists/') == true) {
          final id = settings.name!.split('/').last;
          return NoAnimationMaterialPageRoute(builder: (_) => PsychologistDetail(id: id));
        }
        if (settings.name?.startsWith('/blog/') == true && settings.name != blog) {
          final id = settings.name!.split('/').last;
          return NoAnimationMaterialPageRoute(builder: (_) => ArticleDetail(id: id));
        }
        return NoAnimationMaterialPageRoute(builder: (_) => const NotFoundPage());
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

  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void replaceWith(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  static void navigateWithArguments(BuildContext context, String routeName, Object arguments) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
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
            const Text('404', style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('Страница не найдена', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    );
  }
}
