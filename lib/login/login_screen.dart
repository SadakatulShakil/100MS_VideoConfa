import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_confa/login/widget/text_from_field.dart';
import 'package:video_confa/register/register_screen.dart';

import '../../utill/color_resources.dart';
import '../home/home_screen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset('assets/images/back_page.png'),
              Positioned(
                top: 320,
                left: 25,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: 300,
                    height: 400,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: loginPage.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Welcome',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        Text(
                          'Login with your ID & Password',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        GetTextFormField(
                          //onChangeText: dataProvider.updateTextFieldUsersEmail,
                          //controller: emailController,
                          hintName: "Enter ID",
                          inputType: TextInputType.text,
                        ),
                        GetTextFormField(
                          hintName: 'Enter Password',
                          inputType: TextInputType.text,
                          isObscureText: true,
                        ),
                        SizedBox(height: 40),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement sign-in logic here
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()),
                                      (route) => false);
                            },
                            style: ElevatedButton.styleFrom(

                              primary: accent, // Set the background color here
                            ),
                            child: Text('Login', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'If you are new, ',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                            },
                            child: Text(
                              'Register Now',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ),
                        ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

