import 'dart:io';
import 'package:app/screens/crud_content/Authentication/login_student_screen.dart';
import 'package:app/screens/explore.dart';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class AddCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class AddCategory extends StatefulWidget{

  static const PREFERENCES_IS_FIRST_LAUNCH_STRING = "PREFERENCES_IS_FIRST_LAUNCH_STRING";
  static const routeName = '/addCategory';
  final String id;
  final String nombre;
  final String email;
  AddCategory({required this.id,required this.nombre,required this.email});
  _AddCategoryState createState() => _AddCategoryState();

}

class _AddCategoryState extends State<AddCategory> {

  final _keyForm = GlobalKey<FormState>();
  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final keyThree = GlobalKey();
  final keyFour = GlobalKey();

  bool visible = false;
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();
  late BuildContext myContext;
  @override

  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(
    //         (_) {
    //       _isFirstLaunch().then((result){
    //         if(result)
    //           ShowCaseWidget.of(context).startShowCase([keyOne]);
    //       });
    //     }
    // );
  }

  void startTutorial(){
    ShowCaseWidget.of(myContext).startShowCase([keyOne,keyTwo,keyFour]);
  }



  String msg = '';
  Future _AddCategory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    var url ="http://192.168.56.1:3002/api/categoria/categoria";
      String title = TitleController.text;
      String Description = DescriptionController.text;
      var token= sharedPreferences.getString("token");
      var response = await http.post(Uri.parse(url),
        body:jsonEncode({'nombre':title,'descripcion': Description}),
        headers:  { HttpHeaders.contentTypeHeader: 'application/json','auth-token':'${token}'}
        );
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Se ha creado la categoria con exito"),
            actions: <Widget>[
              ElevatedButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Explorer(id:widget.id,email: widget.email,nombre: widget.nombre))
                  );
                  // Navigator.pushReplacementNamed(context, LoginScreenStudent.routeName);
                },
              ),
            ],
          );
        },
      );
    }
    else {
      jsonResponse = json.decode(response.body);
      msg= jsonResponse['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(jsonResponse['message']),
            actions: <Widget>[
              ElevatedButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
        builder:
        Builder(builder: (context) {
      myContext = context;
       return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:  Color.fromRGBO(25,104,68, 1),
          title: Center(child: Text('Agregar categoria'),),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
               Showcase(
                 key: keyThree,
                 description: 'Alguna maricada',
                 child: IconButton(
                  icon: Icon(Icons.info_rounded),
                  onPressed: () {
                    startTutorial();
                  },
              ),
               ),
          ],
        ),

        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              color: Colors.white,
              width: double.infinity,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child:
                  Form(
                    key: _keyForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Image.asset(
                        //   "assets/images/enroll.php",
                        //   height: 130,
                        // ),
                        SizedBox(
                          height: 40,
                        ),
                        Showcase(
                          key: keyOne,
                          description: "El titulo debe ser informativo y entendible",
                          child: TextFormField(
                            validator: (valor){
                              if(valor!.isEmpty){
                                return 'Este campo no puede estar vacío';
                              }
                            },
                            controller: TitleController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18, color: Colors.black54),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Titulo',
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green,width: 20),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Showcase(
                          key: keyTwo,
                          // title: 'title',
                          description: 'La descripcion debe ser breve y clara, una pequeña introduccion de la tematica',
                          child: TextFormField(
                            validator: (valor) {
                              if (valor!.isEmpty) {
                                return 'El campo descripcion es obligatorio';
                              }
                              if (valor.length<15 || valor.length>150) {
                                return 'El campo descripcion debe contener minimo 15 y máximo 200 caracteres';
                              }

                            },
                            keyboardType:TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            controller: DescriptionController,
                            // obscureText: true,
                            style: TextStyle(fontSize: 18, color: Colors.black54),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Descripcion',
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green,width: 20),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Showcase(
                          key: keyFour,
                          description: 'Cuando estés seguro con el titulo y descripcion que decidiste, presiona en el boton "Agregar categoria"',
                          child: OutlinedButton(
                            child: Text(
                              'Agregar categoria',
                              style: TextStyle(
                                  fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold
                              ),
                            ),
                            style:
                            OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor:  Color.fromRGBO(25,104,68, 1),
                                padding: EdgeInsets.all(13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )
                            ),
                            onPressed: () {
                              if(_keyForm.currentState!.validate()){
                                print("validacion exitosa");
                                _AddCategory();
                              }else{
                                print("validacion erronea");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
        }
    ));
  }

}

class CustomShowcaseWidget extends StatelessWidget {
  final Widget child;
  final String description;
  final GlobalKey globalKey;

  const CustomShowcaseWidget({
    required this.description,
    required this.child,
    required this.globalKey,
  });

  @override
  Widget build(BuildContext context) => Showcase(
    key: globalKey,
    showcaseBackgroundColor: Colors.pink.shade400,
    contentPadding: EdgeInsets.all(12),
    showArrow: false,
    disableAnimation: true,
    // title: 'Hello',
    // titleTextStyle: TextStyle(color: Colors.white, fontSize: 32),
    description: description,
    descTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    // overlayColor: Colors.white,
    // overlayOpacity: 0.7,
    child: child,
  );
}

// Future<bool> _isFirstLaunch() async{
//   final sharedPreferences = await SharedPreferences.getInstance();
//   bool isFirstLaunch = sharedPreferences.getBool(AddCategory.PREFERENCES_IS_FIRST_LAUNCH_STRING) ?? true;
//
//   if(isFirstLaunch)
//     sharedPreferences.setBool(AddCategory.PREFERENCES_IS_FIRST_LAUNCH_STRING, false);
//
//   return isFirstLaunch;
// }


