import 'dart:async';
import 'package:app/screens/crud_content/Authentication/Utils.dart';
import 'package:app/screens/getting_started.dart';
import 'package:app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  bool isEmailVerified=false;
  bool canResendEmail=false;
  late User user;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();
      Timer.periodic(Duration(seconds: 5), (_) {
        checkEmailVerified();
      });
    }

  }
  Future sendVerificationEmail()async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() =>canResendEmail=false);
        await Future.delayed(Duration(seconds: 20));
      setState(() =>canResendEmail=true);
    }catch(e){
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState((){
      isEmailVerified=FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
    }



  @override
  Widget build(BuildContext context) => isEmailVerified
    ? GettingStarted()
  // HomeScreen(id: id, email: email, name: name)
      : Scaffold(
    appBar: AppBar(
      title: Text('Verificando email'),
    ) ,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Un correo ha sido enviado, por favor verificar',
              style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            ),
            SizedBox(height: 24,),
            ElevatedButton.icon(
                icon: Icon(Icons.email,size: 32),
                label: Text('Reenviar correo',style: TextStyle(fontSize: 24)),
                onPressed: canResendEmail ? sendVerificationEmail:null,
            ),
            SizedBox(height:8),
            ElevatedButton.icon(
                icon: Icon(Icons.email,size: 32),
                label: Text('Cancelar',style: TextStyle(fontSize: 24)),
                onPressed:()=> FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
    );



}
