import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Pages/Other/order_info.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/appinfomodel.dart';
import 'package:vendor/beanmodel/orderbean/todayorderbean.dart';

class TomorrowOrder extends StatefulWidget {
  const TomorrowOrder({super.key});

  @override
  State<TomorrowOrder> createState() => _TomorrowOrderState();
}

class _TomorrowOrderState extends State<TomorrowOrder> {
  List<TodayOrderMain> newOrders = [];
  bool isAppActive = false;
  var http = Client();
  bool isLoading = false;
  dynamic apCurrency;

  @override
  void initState() {
    super.initState();
    hitAppInfo();
  }

  @override
  void dispose() {
    http.close();
    super.dispose();
  }

  void hitAppInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var http = Client();
    http.post(appInfoUri, body: {'user_id': ''}).then((value) {
      debugPrint(value.body);
      if (value.statusCode == 200) {
        AppInfoModel data1 = AppInfoModel.fromJson(jsonDecode(value.body));
        if (data1.status == "1" || data1.status == 1) {
          prefs.setString('app_currency', '${data1.currencySign}');
          prefs.setString('app_referaltext', '${data1.refertext}');
          prefs.setString('numberlimit', '${data1.phoneNumberLength}');
          prefs.setString('imagebaseurl', '${data1.imageUrl}');
          prefs.setString('liveChat', '${data1.liveChat}');
          getImageBaseUrl();
        }
      }
    }).catchError((e) {
      debugPrint(e);
    });
    getOrderList();
  }

  void getOrderList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      apCurrency = prefs.getString('app_currency');
    });
    http.post(storenextdayOrdersUri, body: {'store_id': '${prefs.getInt('store_id')}'}).then((value) {
      debugPrint(value.body);
      if (value.statusCode == 200) {
        var jsD = jsonDecode(value.body) as List;
        if ('${jsD[0]['order_details']}'.toUpperCase() != 'NO ORDERS FOUND') {
          newOrders = List.from(jsD.map((e) => TodayOrderMain.fromJson(e)).toList());
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
        newOrders.clear();
      });
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Container(
      child: (!isLoading && newOrders.isNotEmpty)
          ? ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              physics: const ScrollPhysics(),
              itemCount: newOrders.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildCompleteCard(context, newOrders[index]);
              })
          : isLoading
              ? const Align(
                  widthFactor: 40,
                  heightFactor: 40,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : Align(
                  alignment: Alignment.center,
                  child: Text(locale!.noorderfnd!),
                ),
    );
  }

  GestureDetector buildCompleteCard(BuildContext context, TodayOrderMain mainP) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderInfo(mainP))).then((value) {
          if (value != null && value) {
            getOrderList();
          }
        });
      },
      child: Card(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
        color: Colors.white,
        elevation: 1,
        child: Column(
          children: [
            buildItem(context, mainP),
            buildOrderInfoRow(context, '$apCurrency ${mainP.orderPrice.toStringAsFixed(2)}', '${mainP.paymentMode}', '${mainP.orderStatus}'),
          ],
        ),
      ),
    );
  }

  Container buildOrderInfoRow(BuildContext context, String price, String prodID, String orderStatus, {double borderRadius = 8}) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
        color: Colors.grey[100],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12),
      child: Row(
        children: [
          buildGreyColumn(context, locale.payment!, price),
          const Spacer(),
          buildGreyColumn(context, locale.paymentmode!, prodID),
          const Spacer(),
          buildGreyColumn(context, locale.orderStatus!, orderStatus, text2Color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  Padding buildItem(BuildContext context, TodayOrderMain mainP) {
    var locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/icon.png', height: 70)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      mainP.userName,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      mainP.userPhone,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      mainP.userAddress,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Text('${locale.orderedOn!} ${mainP.orderDetails![0].orderDate}', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 10.5)),
                  ],
                ),
              ),
            ],
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: 0,
            bottom: 0,
            child: Text(
              '${locale.orderID!} #${mainP.cartId}',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 10.5),
            ),
          ),
        ],
      ),
    );
  }

  Column buildGreyColumn(BuildContext context, String text1, String text2, {Color text2Color = Colors.black}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text1, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 11)),
        const SizedBox(height: 8),
        LimitedBox(
          maxWidth: 100,
          child: Text(text2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: text2Color)),
        ),
      ],
    );
  }
}
