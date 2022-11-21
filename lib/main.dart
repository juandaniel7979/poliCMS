import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/providers/category_provider.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/screens/feedback_screen.dart';
import 'package:poli_gestor_contenidos/screens/screens.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:poli_gestor_contenidos/services/notifications_service.dart';
import 'package:poli_gestor_contenidos/services/publications_services.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider( create: ( _ ) => AuthService()),
        ChangeNotifierProvider( create: ( _ ) => ThemeProvider(isDarkMode: Preferences.isDarkMode )),
        ChangeNotifierProvider( create: ( _ ) => PublicationsServices()),
        ChangeNotifierProvider( create: ( _ ) => CategoryProvider()),
        
      ],
      child: const MyApp(),
      )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material  App',
      initialRoute: ListCategoriesScreen.routerName,
      routes: {
        CategoryScreen.routerName: ( _ ) => const  CategoryScreen(),
        HomeScreen.routerName: ( _ ) => const HomeScreen(),
        LoginScreen.routerName: ( _ ) => const LoginScreen(),
        SettingsScreen.routerName: ( _ ) => const SettingsScreen(),
        FeedbackScreen.routerName: ( _ ) => const FeedbackScreen(),
        PublicationEditScreen.routerName: ( _ ) => const PublicationEditScreen(),
        ListCategoriesScreen.routerName: ( _ ) => const ListCategoriesScreen(),
        RegisterScreen.routerName: ( _ ) => const RegisterScreen(),
        CategoryEditScreen.routerName: ( _ ) => const CategoryEditScreen(),
        
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      
    );
  }
}