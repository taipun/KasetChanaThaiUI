import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:kasetchana_flutter/widgets/toasts.dart';
import 'dart:convert' as convert;

import 'login.screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  String userEmail;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: CustomWidgets.appBar(context, "", []),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: Text("ลืมรหัสผ่าน",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 36))),
                      Container(
                          padding:
                              EdgeInsets.only(top: 20, left: 60, right: 60),
                          child: Text(
                              "ใส่อีเมลของคุณเพื่อรับลิงค์สำหรับตั้งรหัสผ่านใหม่",
                              textAlign: TextAlign.center)),
                      SizedBox(height: 50),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Material(
                          borderRadius: AppConstants.borderRadius(),
                          elevation: AppConstants.elevation,
                          child: TextFormField(
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
                              hintText: 'ใส่อีเมลของคุณ',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        height: AppConstants.buttonHeight,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () => this.onResetPassword(),
                          child: Text("ตั้งรหัสผ่านใหม่"),
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }

  void onResetPassword() {
    this._formKey.currentState.save();
    if (this._formKey.currentState.validate()) {
      AuthService().forgotPassword(this.userEmail).then((res) {
        var responseData = convert.jsonDecode(res.body);
        if (res.statusCode == 200) {
          Toasts.toastSuccess(context, 'สำเร็จ ตรวจสอบอีเมล', 1);
          Navigator.of(context).pop();
        } else {
          Toasts.toastError(context, '${responseData['message']}', 2);
        }
      }).catchError((error) => Toasts.toastError(context, 'เกิดข้อผิดพลาด', 2));
    }
  }
}
