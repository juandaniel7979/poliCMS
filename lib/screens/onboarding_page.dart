import 'package:app/Widgets/button_widget_onboarding.dart';
import 'package:app/screens/getting_started.dart';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {




_OnBoardingPageState createState() => _OnBoardingPageState();
}



class _OnBoardingPageState extends State<OnBoardingPage> {


  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getString("token") != null && sharedPreferences.getString("rol")=="profesor" || sharedPreferences.getString("rol")=="estudiantei") {
      // Navigator.pushReplacementNamed(context, );
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>HomeScreen()));
    }

  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Comparte tu conocimiento',
          body: 'Organiza tu información y compartela para alguien que le pueda servir',
          image: buildImage('assets/images/ebook.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Explora las diferentes tematicas',
          body: 'Disponible desde el alcance de tu telefono',
          image: buildImage('assets/images/readingbook.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Interfaz facil e Intuitiva',
          body: 'Para garantizar tu experiencia de usuario',
          image: buildImage('assets/images/learn.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Todos somos politecnico',
          body: 'Sigamos aprendiendo juntos',
          footer: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:  Color.fromRGBO(25,104,68, 1),
            ),
            child: Text("Comienza a explorar",
            style: TextStyle(color: Colors.white),),
            onPressed: () => goToHome(context),
          ),
          image: buildImage('assets/images/POLI-JIC-2.png'),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text('Explorar', style: TextStyle(color: Colors.white,fontWeight:FontWeight.w600,fontSize: 25)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('Saltar',style: TextStyle(color: Colors.white,fontWeight:FontWeight.w600,fontSize: 25),),
      onSkip: () => goToHome(context),
      next: Icon(Icons.arrow_forward,color: Colors.white,),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: Color.fromRGBO(25,104,68, 1),
      // controlsPadding: EdgeInsets.symmetric(horizontal: 50),
      skipOrBackFlex: 0,
      nextFlex: 0,
      // isProgressTap: false,
      // isProgress: false,
      // showNextButton: false,
      // freeze: true,
      // animationDuration: 1000,
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => GettingStarted()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    activeColor: Colors.white,
    colors: [Colors.white,Colors.white,Colors.white,Colors.white],
    size: Size(10, 10),
    activeSize: Size(13, 13),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color:Colors.white),
    bodyTextStyle: TextStyle(fontSize: 20,color: Colors.white),
    // descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: Color.fromRGBO(255, 202, 115, 1),
  );
}
