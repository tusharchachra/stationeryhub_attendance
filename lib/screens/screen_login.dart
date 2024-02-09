import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/helpers/size_config.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({
    super.key,
  });

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController phoneNumController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
      isLoading: false,
      scaffoldDecoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.fill)),
      bodyWidget: SizedBox(
        width: SizeConfig.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Stationery Hub',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.getSize(10),
              ),
            ),
            Text(
              'Attendance Marking System',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: SizeConfig.getSize(3),
              ),
            ),
            SizedBox(
              width: SizeConfig.getSize(70),
              child: TextFormField(
                controller: phoneNumController,
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 5,
                ),
                keyboardType: TextInputType.phone,
                autofocus: false,
                maxLength: 10,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                    prefix: Text(
                      '+91-',
                      style: TextStyle(color: Colors.white),
                    ),
                    prefixIcon: Icon(Icons.phone),
                    prefixIconColor: Colors.white,
                    fillColor: Colors.black38,
                    counterText: '',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(40.0)))),
              ),
            ),
            GestureDetector(
              child: Container(
                color: Colors.white,
                child: Text('Submit'),
              ),
            )
          ],
        ),
      ),
      pageTitle: '',
    );
  }
}
