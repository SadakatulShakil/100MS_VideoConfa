import 'package:flutter/material.dart';

class MoreOptionBottomSheet extends StatefulWidget {
  @override
  _MoreOptionBottomSheetState createState() => _MoreOptionBottomSheetState();
}

class _MoreOptionBottomSheetState extends State<MoreOptionBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'More options', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.message, size: 30),
                  SizedBox(width: 12,),
                  Text('Messages', style: TextStyle(fontSize: 18, letterSpacing: 2),)
                ],
              ),
            ),
            Divider(thickness: 1,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.add_to_home_screen, size: 30,),
                  SizedBox(width: 12,),
                  Text('Share screen', style: TextStyle(fontSize: 18, letterSpacing: 2))
                ],
              ),
            ),
            Divider(thickness: 1,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.back_hand, size: 30),
                  SizedBox(width: 12,),
                  Text('Raise hand', style: TextStyle(fontSize: 18, letterSpacing: 2))
                ],
              ),
            ),
            Divider(thickness: 1,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.people, size: 30),
                  SizedBox(width: 12,),
                  Text('People', style: TextStyle(fontSize: 18, letterSpacing: 2))
                ],
              ),
            ),
            Divider(thickness: 1,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.share, size: 30),
                  SizedBox(width: 12,),
                  Text('Share app', style: TextStyle(fontSize: 18, letterSpacing: 2))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}