import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/kasetplan.model.dart';
import 'package:kasetchana_flutter/models/user.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/services/kasetplan.service.dart';
import 'package:kasetchana_flutter/services/user.service.dart';
import 'package:kasetchana_flutter/services/weather.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/Constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;

import 'package:kasetchana_flutter/widgets/toasts.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = true;
  String dropdownValue = "";
  bool checkbox = false;
  bool _isUploadImage = false;
  ImagePicker _picker = ImagePicker();
  String imagePath = "";
  List<String> dropdownItems = <String>[];
  User _user = new User();
  String confirmPassword = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitRegion() async {
    await WeatherService().getRegion().then((value) {
      setState(() {
        this.dropdownValue = value[0].nameEng;
        value.forEach((element) {
          this.dropdownItems.add(element.nameEng);
        });
        this.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitRegion();
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Center(
            child: Scaffold(
              appBar: CustomWidgets.appBar(context, "สมัครสมาชิก", []),
              body: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => this.selectImage(),
                            child: Container(
                                child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: this._isUploadImage == false
                                  ? AssetImage('assets/images/placeholder.png')
                                  : NetworkImage(this.imagePath),
                            )),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text("เพิ่มรูปภาพ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Material(
                              borderRadius: AppConstants.borderRadius(),
                              elevation: AppConstants.elevation,
                              child: TextFormField(
                                onChanged: (value) => setState(() {
                                  this._user.userName = value;
                                }),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppConstants.borderRadius(),
                                        borderSide: BorderSide(
                                            color: AppColors.borderColor)),
                                    border: OutlineInputBorder(
                                      borderRadius: AppConstants.borderRadius(),
                                    ),
                                    hintText: 'ใส่ชื่อของคุณ'),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Material(
                              borderRadius: AppConstants.borderRadius(),
                              elevation: AppConstants.elevation,
                              child: TextFormField(
                                onChanged: (value) => setState(() {
                                  this._user.userEmail = value;
                                }),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppConstants.borderRadius(),
                                        borderSide: BorderSide(
                                            color: AppColors.borderColor)),
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
                                onChanged: (value) => setState(() {
                                  this._user.userPassword = value;
                                }),
                                obscureText: true,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppConstants.borderRadius(),
                                        borderSide: BorderSide(
                                            color: AppColors.borderColor)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            AppConstants.borderRadius()),
                                    hintText: 'ใส่รหัสผ่านของคุณ'),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Material(
                              borderRadius: AppConstants.borderRadius(),
                              elevation: AppConstants.elevation,
                              child: TextFormField(
                                onChanged: (value) => setState(() {
                                  this.confirmPassword = value;
                                }),
                                obscureText: true,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppConstants.borderRadius(),
                                        borderSide: BorderSide(
                                            color: AppColors.borderColor)),
                                    border: OutlineInputBorder(
                                      borderRadius: AppConstants.borderRadius(),
                                    ),
                                    hintText: 'ยืนยันรหัสผ่านของคุณ'),
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: AppConstants.borderRadius(),
                                    border: Border.all(
                                        color: AppColors.borderColor)),
                                child: Material(
                                  borderRadius: AppConstants.borderRadius(),
                                  elevation: AppConstants.elevation,
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        value: this.dropdownValue,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            this.dropdownValue = newValue;
                                            this._user.userRegion = newValue;
                                          });
                                        },
                                        items: this
                                            .dropdownItems
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(value)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      activeColor: AppColors.primaryColor,
                                      value: this.checkbox,
                                      onChanged: (value) {
                                        setState(() {
                                          this.checkbox = value;
                                        });
                                      }),
                                  GestureDetector(
                                    onTap: () => print("checkbox"),
                                    child: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "ฉันยินยอมต่อ ",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      TextSpan(
                                          text: "เงื่อนไขในการใช้งาน",
                                          style: TextStyle(color: Colors.blue)),
                                    ])),
                                  ),
                                ],
                              )),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            height: AppConstants.buttonHeight,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () => this.onSave(),
                              child: Text("สมัครสมาชิก"),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          );
  }

  Future<void> selectImage() async {
    await _picker.pickImage(source: ImageSource.gallery).then((res) {
      AuthService().uploadImage(res.path).then((res2) async {
        var responseData =
            convert.jsonDecode(await res2.stream.bytesToString());
        setState(() {
          if (res2.statusCode == 200) {
            this._isUploadImage = true;
            this.imagePath = responseData[0];
            this._user.userPictureurl = responseData[0];
            Toasts.toastSuccess(context, 'เลือกรูปภาพสำเร็จ', 1);
          } else {
            this._isUploadImage = false;
            print('selectImage ==> $responseData');
            Toasts.toastError(context, 'เกิดข้อผิดพลาด', 2);
          }
        });
      }).catchError((error) {
        Toasts.toastError(context, 'เกิดข้อผิดพลาด', 2);
      });
    }).catchError((ex) => Toasts.toastWarning(context, 'ไม่ได้เลือกรูปภาพ', 2));
  }

  Future<void> onSave() async {
    if (this.checkbox == true) {
      if (this._user.userPassword == this.confirmPassword) {
        await UserService().create(this._user).then((value) async {
          AuthService().setToken(convert.jsonDecode(value.body)['token']);
          Kasetplan model = new Kasetplan();
          model.kasetUId = convert.jsonDecode(value.body)['result']['_id'];
          model.isActive = true;
          model.planName = 'kaset01';
          await KasetplanService().createKasetplan(model).then((value2) {
            Toasts.toastSuccess(context, 'สมัครใช้งานสำเร็จ', 1);
            Navigator.of(context).pop();
          });
        });
      } else {
        Toasts.toastError(context, 'รหัสผ่านไม่ตรงกัน', 2);
      }
    } else {
      Toasts.toastError(context, 'ไม่ได้ยอมรับเงื่อนไข', 2);
    }
  }
}
