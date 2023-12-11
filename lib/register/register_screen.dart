import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_confa/login/login_screen.dart';
import 'package:video_confa/login/widget/text_from_field.dart';

import '../../utill/color_resources.dart';
import '../home/home_screen.dart';
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String selectedPrefix = 'Mr'; // Default value
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset('assets/images/back_page.png'),
              Positioned(
                top: 150,
                left: 15,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: 320,
                    height: 620,
                    padding: EdgeInsets.all(8),
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
                            'Register Now',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Inside the Row widget
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 55, // Adjust the height as needed
                                child: DropdownButtonFormField<String>(
                                  value: selectedPrefix,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPrefix = value!;
                                    });
                                  },
                                  items: ['Mr', 'Mrs', 'Miss', 'Dr'].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Select Prefix',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: GetTextFormField(
                                hintName: "Name",
                                inputType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),

                        GetTextFormField(
                          //onChangeText: dataProvider.updateTextFieldUsersEmail,
                          //controller: emailController,
                          hintName: "Email",
                          inputType: TextInputType.emailAddress,
                        ),
                        GetTextFormField(
                          //onChangeText: dataProvider.updateTextFieldUsersEmail,
                          //controller: emailController,
                          hintName: "Enter ID",
                          inputType: TextInputType.text,
                        ),
                        GetTextFormField(
                          //onChangeText: dataProvider.updateTextFieldUsersEmail,
                          //controller: emailController,
                          hintName: "phone",
                          inputType: TextInputType.number,
                        ),
                        GetTextFormField(
                          hintName: 'Enter Password',
                          inputType: TextInputType.text,
                          isObscureText: true,
                        ),
                        GetTextFormField(
                          hintName: 'Confirm Password',
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
                            child: Text('Register', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'If already have account, ',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                            },
                            child: Text(
                              'Login here',
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

