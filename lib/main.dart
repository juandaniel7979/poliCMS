import 'package:app/screens/crud_content/List_content.dart';
import 'package:app/screens/crud_content/adds/add_category.dart';
import 'package:app/screens/crud_content/adds/add_content.dart';
import 'package:app/screens/crud_content/adds/add_subcategory.dart';
import 'package:app/screens/crud_content/detail_content.dart';
import 'package:app/screens/crud_content/detail_content_student.dart';
import 'package:app/screens/crud_content/list_categories.dart';
import 'package:app/screens/crud_content/list_subcategories.dart';
import 'package:app/screens/crud_content/edit_subcategories.dart';
import 'package:app/screens/crud_content/Authentication/signup_teacher_screen.dart';
import 'package:app/screens/explore.dart';
import 'package:app/screens/home_screen_student.dart';
import 'package:app/screens/my_categories.dart';
import 'package:app/screens/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/home_screen.dart';
import './screens/details_screen.dart';
import 'screens/crud_content/Authentication/login_student_screen.dart';
import './screens/crud_content/Authentication/login_teacher_screen.dart';
import './screens/crud_content/Authentication/signup_student_screen.dart';
import './screens/getting_started.dart';
import './screens/access_code.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());

}

String token = '';
String id = '';
String id_subcategoria = '';
String id_categoria = '';
String email = '';
String nombre = '';
String categoria = '';
String subcategoria ='';
String descripcion = '';
String url = '';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      // home: GettingStarted(),
      home: OnBoardingPage(),
      routes: {
        GettingStarted.routeName: (_) => GettingStarted(),
        HomeScreen.route: (BuildContext context) =>
            HomeScreen(id: id, email: email, nombre: nombre),
        Explorer.route: (BuildContext context) =>
            Explorer(id: id, email: email, nombre: nombre),
        MyCategories.route: (BuildContext context) =>
            MyCategories(id: id, email: email, nombre: nombre),
        HomeScreenStudent.route: (BuildContext context) =>
            HomeScreenStudent(id: id, email: email, nombre: nombre),
        DetailsScreen.route: (BuildContext context) =>
            DetailsScreen(email: email, nombre: nombre),
        LoginScreenStudent.routeName: (_) => LoginPageStudent(),
        LoginScreenTeacher.routeName: (_) => LoginPageTeacher(),
        SignupScreenStudent.routeName: (_) => SignupPageStudent(),
        SignupScreenTeacher.routeName: (_) => SignupPageTeacher(),
        AccessCode.routeName: (BuildContext context) =>AccessCode(id: id, email: email, nombre: nombre),
        AddCategory.routeName: (BuildContext context) => AddCategory(id: id,email: email, nombre: nombre),
        AddSubcategory.routeName: (BuildContext context) => AddSubcategory(
            id: id,
            id_categoria: id_categoria,
            nombre: nombre,
            email: email,
            categoria: categoria,
            descripcion: descripcion),
        ListSubcategories.route: (BuildContext context) => ListSubcategories(
            id: id,
            id_categoria: id_categoria,
            nombre: nombre,
            email: email,
            categoria: categoria,
            descripcion: descripcion
        ),
        DetailContentStudent.route: (BuildContext context) =>DetailContentStudent(
                id: id,
                nombre: nombre,
                email: email,
                categoria: categoria,
                descripcion: descripcion),
        EditSubcategory.routeName: (BuildContext context) => EditSubcategory(
            id: id,
            id_categoria: id_categoria,
            id_subcategoria: id_subcategoria,
            nombre: nombre,
            email: email,
            categoria: categoria,
            descripcion: descripcion
        ),
        ListContent.route:(BuildContext context)=> ListContent(
                id: id,
                id_subcategoria:id_subcategoria,
                nombre: nombre,
                email: email,
                subcategoria: subcategoria,
                descripcion: descripcion,
                url:url
        ),DetailContent.route:(BuildContext context)=> DetailContent(
                id: id,
                id_subcategoria:id_subcategoria,
                nombre: nombre,
                email: email,
                subcategoria: subcategoria,
                descripcion: descripcion,
                url:url
        ),
        AddContent.routeName:(BuildContext context)=> AddContent(
            id: id,
            id_subcategoria:id_subcategoria,
            nombre: nombre,
            email: email,
            subcategoria: subcategoria,
            descripcion: descripcion,
            url:url
        ),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token")==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> GettingStarted()), (route) => false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
          return HomeScreen(id: id, email: email, nombre: nombre);
          }else{
            return GettingStarted();
          }
        },
      ),
    );
  }
}
