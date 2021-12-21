import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/screens/home.screen.dart';
import 'package:kasetchana_flutter/screens/register.screen.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/toasts.dart';
import 'dart:convert' as convert;
import 'forgot-password.screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String userEmail;
  String userPassword;

  @override
  void initState() {
    super.initState();
    this.onInit();
  }

  void onInit() {
    // this._emailController.text = 'jay44411@gmail.com';
    // this._passwordController.text = 'vzm83e';
    AuthService().getRemember().then((remember) {
      if (remember == 'true') {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'))),
                  ),
                  Container(
                    child: Material(
                      borderRadius: AppConstants.borderRadius(),
                      elevation: AppConstants.elevation,
                      child: TextFormField(
                        controller: this._emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        onSaved: (value) => setState(() {
                          this.userEmail = value;
                        }),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius(),
                                borderSide:
                                    BorderSide(color: AppColors.borderColor)),
                            border: OutlineInputBorder(
                              borderRadius: AppConstants.borderRadius(),
                            ),
                            hintText: 'ใส่อีเมลของคุณ'),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Material(
                      borderRadius: AppConstants.borderRadius(),
                      elevation: AppConstants.elevation,
                      child: TextFormField(
                        controller: this._passwordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        onSaved: (value) => setState(() {
                          this.userPassword = value;
                        }),
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: AppConstants.borderRadius(),
                              borderSide:
                                  BorderSide(color: AppColors.borderColor)),
                          border: OutlineInputBorder(
                            borderRadius: AppConstants.borderRadius(),
                          ),
                          hintText: 'ใส่รหัสผ่านของคุณ',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    height: AppConstants.buttonHeight,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () => this.onLogin(),
                      child: Text("เข้าสู่ระบบ"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(RegisterScreen.routeName),
                      // onTap: () => Navigator.of(context)
                      //     .pushReplacementNamed(RegisterScreen.routeName),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "ยังไม่มีบัญชีผู้ใช้",
                              style: TextStyle(color: AppColors.textColor)),
                          TextSpan(
                              text: "สมัครตอนนี้",
                              style: TextStyle(color: AppColors.primaryColor)),
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(ForgotPasswordScreen.routeName),
                      child: Text("ลืมรหัสผ่าน",
                          style: TextStyle(color: AppColors.primaryColor)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(color: AppColors.textColor),
                            )),
                        Expanded(
                            flex: 4,
                            child: Text("เข้าสู่ระบบด้วยโซเชี่ยล",
                                style: TextStyle(color: AppColors.textColor))),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(color: AppColors.textColor),
                            ))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        height: AppConstants.buttonHeight,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () => print("Facebook"),
                          child: Text("Facebook"),
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        height: AppConstants.buttonHeight,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () => print("Google"),
                          child: Text("Google"),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() {
    this._formKey.currentState.save();
    if (this._formKey.currentState.validate()) {
      AuthService().login(this.userEmail, this.userPassword).then((res) {
        var responseData = convert.jsonDecode(res.body);
        if (res.statusCode == 200) {
          Toasts.toastSuccess(context, 'เข้าสู่ระบบสำเร็จ', 1);
          AuthService().setRemember('true');
          AuthService().setToken(responseData['token']);
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else {
          Toasts.toastError(context, '${responseData['message']}', 2);
        }
      }).catchError((error) => Toasts.toastError(context, 'เกิดข้อผิดพลาด', 2));
    }
  }
}
