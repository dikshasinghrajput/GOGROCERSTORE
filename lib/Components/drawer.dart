import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/appinfomodel.dart';
import 'package:vendor/main.dart';

Future getSharedValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // hitAppInfo();
  return prefs.getString('store_name');
}

String? liveChat = '1';

void hitAppInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var http = Client();
  http.post(appInfoUri, body: {'user_id': ''}).then((value) {
    debugPrint(value.body);
    if (value.statusCode == 200) {
      AppInfoModel data1 = AppInfoModel.fromJson(jsonDecode(value.body));
      if ('${data1.status}' == '1') {
        prefs.setString('app_currency', '${data1.currencySign}');
        prefs.setString('app_referaltext', '${data1.refertext}');
        prefs.setString('numberlimit', '${data1.phoneNumberLength}');
        prefs.setString('imagebaseurl', '${data1.imageUrl}');
        prefs.setString('liveChat', '${data1.liveChat}');
        liveChat = prefs.getString('liveChat');
        getImageBaseUrl();
      }
    }
  }).catchError((e) {
    debugPrint(e);
  });
}

Drawer buildDrawer(BuildContext context) {
  var locale = AppLocalizations.of(context)!;
  return Drawer(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/menubg2.png'), fit: BoxFit.cover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 54.0),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  hitAppInfo();
                }
                return Text(
                  (snapshot.hasData) ? '${locale.hey} ${snapshot.data}' : '',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22, letterSpacing: 0.5, color: Colors.white),
                );
              },
              future: getSharedValue(),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildListTile(context, Icons.shopping_cart, locale.myOrders!, PageRoutes.newOrdersDrawer),
                buildListTile(context, Icons.insert_chart, locale.insight!, PageRoutes.insight),
                buildListTile(context, Icons.assignment_returned, locale.myItems!, PageRoutes.myItemsPage),
                buildListTile(context, Icons.account_balance_wallet, locale.myEarnings!, PageRoutes.myEarnings),
                buildListTile(context, Icons.account_box, locale.myProfile!, PageRoutes.myProfile),
                liveChat == "1" ? buildListTile(context, Icons.message, locale.chat!, PageRoutes.chatList) : const SizedBox(),
                buildListTile(context, Icons.notifications_active, locale.notifications!, PageRoutes.notificationList),
                buildListTile(context, Icons.view_list, locale.aboutUs!, PageRoutes.aboutus),
                buildListTile(context, Icons.admin_panel_settings_rounded, locale.tnc!, PageRoutes.tnc),
                buildListTile(context, Icons.chat, locale.helpCentre!, PageRoutes.contactUs),
                buildListTile(context, Icons.language, locale.language!, PageRoutes.chooseLanguage),
                ListTile(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear().then((value) {
                      if(!context.mounted) return;
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                        return const GroceryStoreLogin();
                      }), (Route<dynamic> route) => false);
                    });
                  },
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    locale.logout!,
                    style: const TextStyle(letterSpacing: 2, color: Colors.white),
                  ),
                ),
                const Divider(
                  thickness: 4,
                  color: Colors.transparent,
                )
              ],
            ),
          ))
        ],
      ),
    ),
  );
}

ListTile buildListTile(BuildContext context, IconData icon, String title, var onPress) {
  return ListTile(
    onTap: () {
      Navigator.popAndPushNamed(context, onPress);
    },
    leading: Icon(
      icon,
      color: Colors.white,
    ),
    title: Text(
      title,
      style: const TextStyle(letterSpacing: 2, color: Colors.white),
    ),
  );
}
