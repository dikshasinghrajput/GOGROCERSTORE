import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/custom_button.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/appinfomodel.dart';
import 'package:vendor/beanmodel/citybean/citybean.dart';
import 'package:vendor/beanmodel/id_list.dart';
import 'package:vendor/beanmodel/mapsection/latlng.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showDialogBox = false;
  bool enteredFirst = false;
  int numberLimit = 10;
  dynamic mobileNumber;
  dynamic emailId;
  dynamic fbId;
  TextEditingController sellerNameC = TextEditingController();
  TextEditingController storeNameC = TextEditingController();
  TextEditingController emailAddressC = TextEditingController();
  TextEditingController phoneNumberC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController adminShareC = TextEditingController();
  TextEditingController deliveryRangeC = TextEditingController();
  TextEditingController idNumberC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String? selectCity = 'Select city';
  String? selectId = 'Select Id';
  List<CityDataBean> cityList = [];
  IdListData? idValue;
  List<IdListData> idList = [];
  CityDataBean? cityData;
  AppInfoModel? appinfo;
  late FirebaseMessaging messaging;
  dynamic token;
  File? _image;
  File? idPhoto;
  final picker = ImagePicker();
  int count = 0;

  dynamic lat;
  dynamic lng;

  @override
  void initState() {
    super.initState();
    // addressC.text = 'sonipat';
    hitAsyncInit();
    hitCityData();
    hitIdData();
  }

  void hitAsyncInit() async {
    try {
      await Firebase.initializeApp();
      messaging = FirebaseMessaging.instance;
      messaging.getToken().then((value) {
        token = value;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void hitCityData() {
    setState(() {
      showDialogBox = true;
    });
    var http = Client();
    http.get(cityUri).then((value) {
      if (value.statusCode == 200) {
        CityBeanModel data1 = CityBeanModel.fromJson(jsonDecode(value.body));
        debugPrint(data1.data.toString());
        if (data1.status == "1" || data1.status == 1) {
          setState(() {
            cityList.clear();
            cityList = List.from(data1.data);
            selectCity = cityList[0].cityName;
            cityData = cityList[0];
          });
        } else {
          setState(() {
            selectCity = 'Select your city';
            cityData = null;
          });
        }
      } else {
        setState(() {
          selectCity = 'Select your city';
          cityData = null;
        });
      }
      setState(() {
        showDialogBox = false;
      });
    }).catchError((e) {
      setState(() {
        selectCity = 'Select your city';
        cityData = null;
        showDialogBox = false;
      });
      debugPrint(e);
    });
  }

  void hitIdData() {
    setState(() {
      showDialogBox = true;
    });
    var http = Client();
    http.get(storeIdList).then((value) {
      if (value.statusCode == 200) {
        IdListModel data1 = IdListModel.fromJson(jsonDecode(value.body));
        debugPrint(data1.data.toString());
        if ('${data1.status}' == '1') {
          setState(() {
            idList.clear();
            idList = List.from(data1.data);
            selectId = 'Select Id';
            // selectId = idList[0];
          });
        } else {
          setState(() {
            selectId = 'Select Id';
            // cityData = null;
          });
        }
      } else {
        setState(() {
          selectId = 'Select Id';
          // cityData = null;
        });
      }
      setState(() {
        showDialogBox = false;
      });
    }).catchError((e) {
      setState(() {
        selectId = 'Select Id';
        // cityData = null;
        showDialogBox = false;
      });
      debugPrint(e);
    });
  }

  _imgFromCamera() async {
    var pathd = await getApplicationDocumentsDirectory();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      compressImageFile(_image!, '${pathd.path}/${DateTime.now()}.jpg');
    } else {
      debugPrint('No image selected.');
    }
  }

  _imgFromGallery() async {
    var pathd = await getApplicationDocumentsDirectory();

    picker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        compressImageFile(_image!, '${pathd.path}/${DateTime.now()}.jpg');
      } else {
        debugPrint('No image selected.');
      }
    }).catchError((e) { debugPrint(e); });
  }

  void compressImageFile(File file, String targetPath) async {
    try {
      debugPrint("testCompressAndGetFile");
      final result = await (FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 90,
      ) as FutureOr<File>);
      debugPrint(file.lengthSync().toString());
      debugPrint(result.lengthSync().toString());
      final bytes = result.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      debugPrint('kb $kb');
      if (kb > 1000) {
        setState(() {
          _image = null;
        });
        if(!mounted) return;
        ToastContext().init(context);
        Toast.show('upload image less then 1000 kb',
            gravity: Toast.center, duration: Toast.lengthShort);
      } else {
        setState(() {
          _image = result;
        });
      }
    } catch (e) {
      debugPrint('');
    }
  }

  _imgFromCameraForId() async {
    var pathd = await getApplicationDocumentsDirectory();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        idPhoto = File(pickedFile.path);
      });

      compressImageFileForId(idPhoto!, '${pathd.path}/${DateTime.now()}.jpg');
    } else {
      debugPrint('No image selected.');
    }
  }

  _imgFromGalleryForId() async {
    var pathd = await getApplicationDocumentsDirectory();
    picker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        setState(() {
          idPhoto = File(pickedFile.path);
        });
        compressImageFileForId(idPhoto!, '${pathd.path}/${DateTime.now()}.jpg');
      } else {
        debugPrint('No image selected.');
      }
    }).catchError((e) { debugPrint(e); });
  }

  void compressImageFileForId(File file, String targetPath) async {
    try {
      debugPrint("testCompressAndGetFile");
      final result = await (FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 90,
      ) as FutureOr<File>);
      debugPrint(file.lengthSync().toString());
      debugPrint(result.lengthSync().toString());
      final bytes = result.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      debugPrint('kb $kb');
      if (kb > 1000) {
        setState(() {
          idPhoto = null;
        });
        if(!mounted) return;
        ToastContext().init(context);
        Toast.show('upload image less then 1000 kb',
            gravity: Toast.center, duration: Toast.lengthShort);
      } else {
        setState(() {
          idPhoto = result;
        });
      }
    } catch (e) {
      debugPrint('');
    }
  }

  void _showPicker(context) {
    var locale = AppLocalizations.of(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(locale!.photolib!),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(locale.camera!),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showPickerForId(context) {
    var locale = AppLocalizations.of(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(locale!.photolib!),
                    onTap: () {
                      _imgFromGalleryForId();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(locale.camera!),
                  onTap: () {
                    _imgFromCameraForId();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    if (!enteredFirst) {
      final Map<String, AppInfoModel?> receivedData =
          ModalRoute.of(context)!.settings.arguments as Map<String, AppInfoModel?>;
      enteredFirst = true;
      appinfo = receivedData['appinfo'];
      numberLimit = int.parse('${appinfo!.phoneNumberLength}');
      codeController.text = '+${appinfo!.countryCode}';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale.register!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: kMainColor),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              image: ((_image != null)
                                      ? FileImage(_image!)
                                      : const AssetImage('assets/icon.png'))
                                  as ImageProvider<Object>,
                              height: 80,
                              width: 80,
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              locale.uploadpictext!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: kMainTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  EntryField(
                    label: locale.sellerName,
                    hint: locale.sellerName1,
                    controller: sellerNameC,
                  ),
                  EntryField(
                    label: locale.storename1,
                    hint: locale.storename2,
                    controller: storeNameC,
                  ),
                  EntryField(
                    label: locale.storenumber1,
                    hint: locale.storenumber2,
                    controller: phoneNumberC,
                    keyboardType: TextInputType.phone,
                    maxLength: int.parse('${appinfo!.phoneNumberLength}'),
                    contentPading:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    preFixIcon: Container(
                      alignment: Alignment.center,
                      width: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+${appinfo!.countryCode}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kMainTextColor, fontSize: 18.3),
                          ),
                          Container(
                            width: 2,
                            color: kIconColor,
                            height: 30,
                            margin: const EdgeInsets.only(left: 5),
                          )
                        ],
                      ),
                    ),
                  ),
                  EntryField(
                    label: locale.emailAddress,
                    hint: locale.enterEmailAddress,
                    controller: emailAddressC,
                  ),
                  EntryField(
                    label: locale.adminshare1,
                    hint: locale.adminshare2,
                    controller: adminShareC,
                  ),
                  EntryField(
                    label: locale.password1,
                    hint: locale.password2,
                    controller: passwordC,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 1),
                    child: Text(
                      locale.selectycity1!,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: kMainTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 21.7),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<CityDataBean>(
                      hint: Text(
                        selectCity!,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                      isExpanded: true,
                      iconEnabledColor: kMainTextColor,
                      iconDisabledColor: kMainTextColor,
                      iconSize: 30,
                      items: cityList.map((value) {
                        return DropdownMenuItem<CityDataBean>(
                          value: value,
                          child:
                              Text(value.cityName, overflow: TextOverflow.clip),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectCity = value!.cityName;
                          cityData = value;
                          // showDialogBox = true;
                        });
                        // hitSocityList(value.city_name, locale);
                        debugPrint(value.toString());
                      },
                    ),
                  ),
                  EntryField(
                    label: locale.deliveryrange1,
                    hint: locale.deliveryrange2,
                    controller: deliveryRangeC,
                  ),
                  EntryField(
                    label: locale.storeaddress1,
                    hint: locale.storeaddress2,
                    controller: addressC,
                    readOnly: true,
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.locSearch)
                          .then((value) {
                        if (value != null) {
                          BackLatLng back = value as BackLatLng;
                          setState(() {
                            addressC.text = back.address;
                            lat = double.parse('${back.lat}');
                            lng = double.parse('${back.lng}');
                          });
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 1),
                    child: Text(
                      'Select Id',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: kMainTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 21.7),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<IdListData>(
                      hint: Text(
                        selectId!,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                      isExpanded: true,
                      iconEnabledColor: kMainTextColor,
                      iconDisabledColor: kMainTextColor,
                      iconSize: 30,
                      items: idList.map((value) {
                        return DropdownMenuItem<IdListData>(
                          value: value,
                          child: Text(value.name, overflow: TextOverflow.clip),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectId = value!.name;
                          idValue = value;
                        });
                        // hitSocityList(value.city_name, locale);
                        debugPrint(value.toString());
                      },
                    ),
                  ),
                  idValue != null
                      ? EntryField(
                          label: 'Id Number',
                          hint: 'Enter id number',
                          controller: idNumberC,
                        )
                      : const SizedBox(),
                  idValue != null
                      ? Container(
                          margin: const EdgeInsets.all(08),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 08, right: 08, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _showPickerForId(context);
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  child: idPhoto == null
                                      ? SizedBox(
                                          height: 250,
                                          width: double.infinity,
                                          child: Center(
                                              child: Text(
                                            'Tap to add ${idValue!.name} photo',
                                            //'Tap to add third image',
                                            style: Theme.of(context)
                                                .inputDecorationTheme
                                                .labelStyle,
                                          )),
                                        )
                                      : SizedBox(
                                          height: 250,
                                          width: double.infinity,
                                          child: Image.file(
                                            idPhoto!,
                                            fit: BoxFit.contain,
                                          ),
                                        )),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          showDialogBox
              ? const SizedBox(
                  height: 50,
                  child: Center(
                      widthFactor: 50,
                      heightFactor: 40,
                      child: CircularProgressIndicator(strokeWidth: 3)),
                )
              : CustomButton(onTap: () {
                  if (!showDialogBox) {
                    setState(() {
                      showDialogBox = true;
                    });
                    if (emailValidator(emailAddressC.text)) {
                      if (passwordC.text.length > 6) {
                        if (phoneNumberC.text.length == numberLimit) {
                          if (idValue != null) {
                            if (idNumberC.text != '') {
                              if (_image != null) {
                                if (idPhoto != null) {
                                  hitSignUpUrl(
                                      sellerNameC.text,
                                      storeNameC.text,
                                      phoneNumberC.text,
                                      emailAddressC.text,
                                      passwordC.text,
                                      cityData!.cityName,
                                      adminShareC.text,
                                      deliveryRangeC.text,
                                      addressC.text,
                                      context,
                                      idValue!.name,
                                      idNumberC.text);
                                } else {
                                  setState(() {
                                    showDialogBox = false;
                                  });
                                  ToastContext().init(context);
                                  Toast.show('upload id photo',
                                      gravity: Toast.center,
                                      duration: Toast.lengthShort);
                                }
                              } else {
                                setState(() {
                                  showDialogBox = false;
                                });
                                ToastContext().init(context);
                                Toast.show('upload your trade license',
                                    gravity: Toast.center,
                                    duration: Toast.lengthShort);
                              }
                            } else {
                              setState(() {
                                showDialogBox = false;
                              });
                              ToastContext().init(context);
                              Toast.show('incorect id number',
                                  gravity: Toast.center,
                                  duration: Toast.lengthShort);
                            }
                          } else {
                            setState(() {
                              showDialogBox = false;
                            });
                            ToastContext().init(context);
                            Toast.show('incorectId',
                                gravity: Toast.center,
                                duration: Toast.lengthShort);
                          }
                        } else {
                          setState(() {
                            showDialogBox = false;
                          });
                          ToastContext().init(context);
                          Toast.show(
                              '${locale.incorectMobileNumber}$numberLimit',
                              gravity: Toast.center,
                              duration: Toast.lengthShort);
                        }
                      } else {
                        setState(() {
                          showDialogBox = false;
                        });
                        ToastContext().init(context);
                        Toast.show(locale.incorectPassword!,
                            gravity: Toast.center, duration: Toast.lengthShort);
                      }
                    } else {
                      setState(() {
                        showDialogBox = false;
                      });
                      ToastContext().init(context);
                      Toast.show(locale.incorectEmail!,
                          gravity: Toast.center, duration: Toast.lengthShort);
                    }
                  } else {
                    ToastContext().init(context);
                    Toast.show('Already in progress.',
                        gravity: Toast.center, duration: Toast.lengthShort);
                  }
                })
        ],
      ),
    );
  }

  bool emailValidator(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void hitSignUpUrl(
    dynamic sellerName,
    dynamic storename,
    dynamic storephone,
    dynamic storeemail,
    dynamic password,
    dynamic cityid,
    dynamic adminshare,
    dynamic deliveryrange,
    dynamic address,
    BuildContext context,
    String? idName,
    String idNumber,
  ) async {
    debugPrint("$storename\n$sellerName\n$storephone\n$cityid\n$storeemail\n$deliveryrange\n$password\n$address\n${lat.toString()}\n${lng.toString()}\n$adminshare");
    var requestMulti = http.MultipartRequest('POST', registrationStoreUri);
    requestMulti.fields["store_name"] = '$storename';
    requestMulti.fields["emp_name"] = '$sellerName';
    requestMulti.fields["store_phone"] = '$storephone';
    requestMulti.fields["city"] = '$cityid';
    requestMulti.fields["email"] = '$storeemail';
    requestMulti.fields["del_range"] = '$deliveryrange';
    requestMulti.fields["password"] = '$password';
    requestMulti.fields["address"] = '$address';
    requestMulti.fields["lat"] = '$lat';
    requestMulti.fields["lng"] = '$lng';
    requestMulti.fields["share"] = '$adminshare';
    requestMulti.fields["id_name"] = '$idName';
    requestMulti.fields["id_numb"] = idNumber;
    if (_image != null) {
      String fid = _image!.path.split('/').last;
      requestMulti.files.add(await http.MultipartFile.fromPath(
          'profile', _image!.path,
          filename: fid));
      String fid2 = idPhoto!.path.split('/').last;
      requestMulti.files.add(await http.MultipartFile.fromPath(
          'id_img', idPhoto!.path,
          filename: fid2));
      requestMulti.send().then((values) {
        values.stream.toBytes().then((value) {
          var responseString = String.fromCharCodes(value);
          var jsonData = jsonDecode(responseString);
          if(!context.mounted) return;
          if ('${jsonData['status']}' == '1') {
            Navigator.of(context).pop();
          }
          ToastContext().init(context);
          Toast.show(
              jsonData['message'] != null
                  ? '${jsonData['message']}'
                  : 'Some error occurred.',
              gravity: Toast.center,
              duration: Toast.lengthShort);
          setState(() {
            showDialogBox = false;
          });
        }).catchError((e) {
          debugPrint(e);
          setState(() {
            showDialogBox = false;
          });
        });
      }).catchError((e) {
        setState(() {
          showDialogBox = false;
        });
        debugPrint(e);
      });
    }
  }
}
