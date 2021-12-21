import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/user.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/services/user.service.dart';
import 'package:kasetchana_flutter/utilities/constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:kasetchana_flutter/widgets/toasts.dart';

import 'edit-profile.screen.dart';
import 'login.screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  User _user = new User();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitProfile() async {
    UserService()
        .getUserByEmail(await AuthService().decodeEmail())
        .then((value) => setState(() {
              this._user = value;
              this.isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitProfile();
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Scaffold(
            appBar: CustomWidgets.appBar(context, "ข้อมูลผูใช้", []),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                              child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: this._user.userPictureurl != null
                                ? NetworkImage(this._user.userPictureurl)
                                : AssetImage('assets/images/placeholder.png'),
                            // foregroundImage: AssetImage(
                            //     'assets/images/placeholder.png')
                          )),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(this._user.userName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text("สมาชิก"),
                              GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(EditProfileScreen.routeName)
                                      .whenComplete(() => this.onInitProfile()),
                                  child: Text("แก้ไขข้อมูล"))
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40),
                    Text("จังหวัด",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text("การตั้งค่าแอปพลิเคชั่น",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text("การแจ้งเตือน",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text("รายงานปัญหา",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text("ติดตามเรา",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text("ข้อกำหนดในการใช้งาน",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              child: Container(
                height: 120,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      height: AppConstants.buttonHeight,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () => this.onLogout(),
                        child: Text("ออกจากระบบ"),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("เวอร์ชั่น 1.6.8"),
                  ],
                ),
              ),
            ));
  }

  void onLogout() {
    AuthService().removeToken();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    Toasts.toastSuccess(context, 'ออกจากระบบสำเร็จ', 1);
  }
}
