import 'package:flutter/material.dart';
import 'package:kasetchana_flutter/models/user.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/services/user.service.dart';
import 'package:kasetchana_flutter/services/weather.service.dart';
import 'package:kasetchana_flutter/utilities/colors.dart';
import 'package:kasetchana_flutter/utilities/Constants.dart';
import 'package:kasetchana_flutter/widgets/custom-widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;

import 'package:kasetchana_flutter/widgets/toasts.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = true;
  String dropdownValue = "";
  bool _isUploadImage = false;
  ImagePicker _picker = ImagePicker();
  String imagePath = "";
  List<String> dropdownItems = <String>[];
  User _user = new User();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onInitRegion() async {
    await WeatherService().getRegion().then((value) {
      setState(() {
        this.dropdownValue = value[0].nameEng;
      });
      value.forEach((element) {
        setState(() {
          this.dropdownItems.add(element.nameEng);
        });
      });
    });
  }

  Future<void> onInitProfile() async {
    UserService()
        .getUserByEmail(await AuthService().decodeEmail())
        .then((value) => setState(() {
              this._user = value;
              this._user.userPictureurl != null
                  ? this._isUploadImage = true
                  : this._isUploadImage = false;
              this.dropdownValue = this._user.userRegion;
              this.imagePath = this._user.userPictureurl;
              this.isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading == true) {
      this.onInitRegion();
      this.onInitProfile();
    }

    return this.isLoading
        ? Scaffold(body: CustomWidgets.loading(context, 20))
        : Center(
            child: Scaffold(
              appBar: CustomWidgets.appBar(context, "แก้ไขข้อมูล", []),
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
                                initialValue: this._user.userName,
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
                          // Container(
                          //   padding: EdgeInsets.only(top: 20),
                          //   child: Material(
                          //     borderRadius: AppConstants.borderRadius(),
                          //     elevation: AppConstants.elevation,
                          //     child: TextFormField(
                          //       initialValue: this._user.userEmail,
                          //       onChanged: (value) => setState(() {
                          //         this._user.userEmail = value;
                          //       }),
                          //       decoration: InputDecoration(
                          //           enabled: false,
                          //           filled: true,
                          //           fillColor: Colors.white,
                          //           enabledBorder: OutlineInputBorder(
                          //               borderRadius:
                          //                   AppConstants.borderRadius(),
                          //               borderSide: BorderSide(
                          //                   color: AppColors.borderColor)),
                          //           border: OutlineInputBorder(
                          //             borderRadius: AppConstants.borderRadius(),
                          //           ),
                          //           hintText: 'Enter your email'),
                          //     ),
                          //   ),
                          // ),
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
                            padding: EdgeInsets.only(top: 20),
                            height: AppConstants.buttonHeight,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () => this.onSave(),
                              child: Text("แก้ไขข้อมูล"),
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
    await UserService().update(this._user).then((value) {
      Toasts.toastSuccess(context, 'แก้ไขข้อมูลสำเร็จ', 1);
      Navigator.of(context).pop();
    });
  }
}
