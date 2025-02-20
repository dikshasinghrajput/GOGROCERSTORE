import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/custom_button.dart';
import 'package:vendor/Components/drawer.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/baseurl/baseurlg.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController numberC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController messageC = TextEditingController();
  String? userName;
  String? userNumber;
  int numberlimit = 1;

  var http = Client();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  @override
  void dispose() {
    http.close();
    super.dispose();
  }

  void getProfileDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString('store_name');
      userNumber = preferences.getString('phone_number');
      numberlimit = int.parse('${preferences.getString('numberlimit')}');
      nameC.text = '$userName';
      numberC.text = '$userNumber';
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        title: Text(
          locale.contactUs!
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/icon.png',
                scale: 2.5,
                height: 280,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      locale.callBackReq2!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shadowColor: WidgetStateProperty.all(kHintColor),
                        overlayColor: WidgetStateProperty.all(kHintColor),
                        backgroundColor: WidgetStateProperty.all(kHintColor),
                        foregroundColor: WidgetStateProperty.all(kHintColor),
                      ),
                      onPressed: () {
                        if (!isLoading) {
                          setState(() {
                            isLoading = true;
                          });
                          sendCallBackRequest();
                        }
                      },
                      child: Text(
                        locale.callBackReq1!,
                        style: TextStyle(color: kMainTextColor),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
                child: Text(
                  locale.or!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                child: Text(
                  locale.letUsKnowYourFeedbackQueriesIssueRegardingAppFeatures!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 17),
                ),
              ),
              const Divider(
                thickness: 3.5,
                color: Colors.transparent,
              ),
              EntryField(labelFontSize: 16, controller: nameC, labelFontWeight: FontWeight.w400, label: locale.fullName),
              EntryField(controller: numberC, labelFontSize: 16, maxLength: numberlimit, readOnly: true, labelFontWeight: FontWeight.w400, label: locale.phoneNumber),
              EntryField(hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: kHintColor, fontSize: 18.3, fontWeight: FontWeight.w400), hint: locale.enterYourMessage, controller: messageC, labelFontSize: 16, labelFontWeight: FontWeight.w400, label: locale.yourFeedback),
              const Divider(
                thickness: 3.5,
                color: Colors.transparent,
              ),
              isLoading
                  ? SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: const Align(
                        widthFactor: 40,
                        heightFactor: 40,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CustomButton(
                      label: locale.submit,
                      onTap: () {
                        if (!isLoading) {
                          setState(() {
                            isLoading = true;
                          });
                          sendFeedBack(messageC.text);
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  void sendFeedBack(dynamic message) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    http.post(storeFeedbackUri, body: {
      'store_id': '${preferences.getInt('store_id')}',
      'feedback': '$message',
    }).then((value) {
      if (value.statusCode == 200) {
        var jsData = jsonDecode(value.body);
        if ('${jsData['status']}' == '1') {
          if(!mounted) return;
          ToastContext().init(context);
          Toast.show(jsData['message'], duration: Toast.lengthShort, gravity: Toast.center);
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void sendCallBackRequest() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    http.post(storeCallbackReqUri, body: {
      'store_id': '${preferences.getInt('store_id')}',
    }).then((value) {
      if (value.statusCode == 200) {
        var jsData = jsonDecode(value.body);
        if ('${jsData['status']}' == '1') {
          if(!mounted) return;
          ToastContext().init(context);
          Toast.show(jsData['message'], duration: Toast.lengthShort, gravity: Toast.center);
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }
}
