import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:vendor/Components/drawer.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/orderbean/completedhistory.dart';

class MyEarningsPage extends StatefulWidget {
  const MyEarningsPage({super.key});

  @override
  State<MyEarningsPage> createState() => _MyEarningsPageState();
}

class _MyEarningsPageState extends State<MyEarningsPage> {
  List<CompletedHistoryOrder> newOrders = [];
  bool isLoading = false;
  var http = Client();
  String? storeImage = '';
  String ordersRevenue = '0';
  dynamic apCurrency;

  @override
  void initState() {
    super.initState();
    getOrderList();
  }

  @override
  void dispose() {
    http.close();
    super.dispose();
  }

  void getOrderList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      storeImage = prefs.getString('store_photo');
      apCurrency = prefs.getString('app_currency');
    });
    http.post(storeOrderHistoryUri, body: {'store_id': '${prefs.getInt('store_id')}'}).then((value) {
      debugPrint(value.body);
      if (value.statusCode == 200) {
        if (value.body != '[{"order_details":"no orders found"}]') {
          CompletedHistory history = CompletedHistory.fromJson(jsonDecode(value.body));
          setState(() {
            ordersRevenue = '${history.totalRevenue}';
            newOrders.clear();
            newOrders = List.from(history.data!);
          });
        } else {
          setState(() {
            newOrders.clear();
          });
        }
      } else {
        setState(() {
          newOrders.clear();
        });
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
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: buildDrawer(context),
      body: Stack(
        children: [
          Image.network(
            storeImage!,
            height: 180,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: AppBar(
              title: Text(
                locale.myEarnings!,
                style: const TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
                  child: Text(
                    locale.recentTransactions!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                (!isLoading)
                    ? (newOrders.isNotEmpty)
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            shrinkWrap: true,
                            itemCount: newOrders.length,
                            itemBuilder: (context, index) {
                              return buildTransactionCard(context, newOrders[index]);
                            })
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            alignment: Alignment.center,
                            child: Text(locale.nohistoryfound!),
                          )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return buildTransactionSHCard();
                        }),
              ],
            ),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 130,
            start: 0,
            end: 0,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    blurRadius: 0.0, // soften the shadow
                    spreadRadius: 0.5, //extend the shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 80,
                      child: Center(
                        child: (!isLoading)
                            ? RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(text: '${locale.revenue!}\n', style: Theme.of(context).textTheme.titleSmall),
                                  TextSpan(text: '$apCurrency $ordersRevenue', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                                ]))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 60,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 60,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const Spacer(),
                    VerticalDivider(
                      color: Colors.grey[400],
                      width: 20,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 80,
                      child: Center(
                        child: (!isLoading)
                            ? RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(text: '${locale.orders!}\n', style: Theme.of(context).textTheme.titleSmall),
                                  TextSpan(text: (newOrders.isNotEmpty) ? '${newOrders.length}' : '0', style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 2, color: Theme.of(context).colorScheme.onPrimaryContainer)),
                                ]))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 60,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 60,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildTransactionCard(BuildContext context, CompletedHistoryOrder newOrder) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    newOrder.data![0].varientImage,
                    fit: BoxFit.fill,
                    height: 70,
                    width: 80,
                  )),
              const SizedBox(
                width: 10,
              ),
              RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.titleMedium, children: <TextSpan>[
                TextSpan(text: '${newOrder.userName}\n'),
                TextSpan(text: '${locale.deliveryDate!} ${newOrder.deliveryDate}\n\n', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12, height: 1.3)),
                TextSpan(text: '${locale.orderID!} ', style: Theme.of(context).textTheme.titleSmall!.copyWith(height: 0.5)),
                TextSpan(text: '#${newOrder.cartId}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0.5, fontWeight: FontWeight.w500)),
              ])),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Text(
              '\n\n$apCurrency ${newOrder.price}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: '${newOrder.orderStatus}'.toUpperCase() == 'Completed'.toUpperCase() ? Theme.of(context).colorScheme.onSecondaryContainer : kRedColor, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionSHCard() {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.white,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 70,
                      width: 70,
                      color: Colors.grey[300],
                    )),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
