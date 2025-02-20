import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:vendor/Components/drawer.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/revenue/topselling.dart';

class TopSellingItem {
  TopSellingItem(this.img, this.name, this.sold, this.price);

  String img;
  String name;
  String sold;
  String price;
}

class InsightPage extends StatefulWidget {
  const InsightPage({super.key});

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  var http = Client();

  List<TopSellingItemsR> topSellingItems = [];
  late TopSellingRevenueOrdCount orderCount;
  bool isLoading = true;
  dynamic apCurrency;

  String? storeImage = '';

  @override
  void initState() {
    super.initState();
    getRevenue();
  }

  @override
  void dispose() {
    http.close();
    super.dispose();
  }

  void getRevenue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      storeImage = prefs.getString('store_photo');
      apCurrency = prefs.getString('app_currency');
    });
    http.post(storeProductRevenueUri, body: {'store_id': '${prefs.getInt('store_id')}'}).then((value) {
      if (value.statusCode == 200) {
        TopSellingRevenueOrdCount topSellingRevenueOrdCount = TopSellingRevenueOrdCount.fromJson(jsonDecode(value.body));
        setState(() {
          orderCount = topSellingRevenueOrdCount;
        });
        if ('${topSellingRevenueOrdCount.status}' == '1') {
          setState(() {
            topSellingItems.clear();
            topSellingItems = List.from(topSellingRevenueOrdCount.data!);
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
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
          (storeImage != null && storeImage!.isNotEmpty)
              ? Image.network(
                  '$storeImage',
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                )
              : SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: AppBar(
              title: Text(
                locale.insight!,
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
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
                    locale.topSellingItems!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                (!isLoading)
                    ? (topSellingItems.isNotEmpty)
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            shrinkWrap: true,
                            itemCount: topSellingItems.length,
                            itemBuilder: (context, index) {
                              return buildTopSellingItemCard(context, topSellingItems[index].varientImage, topSellingItems[index].productName, '${topSellingItems[index].count}', '${topSellingItems[index].revenue}');
                            })
                        : Align(
                            alignment: Alignment.center,
                            child: Text(locale.nohistoryfound!),
                          )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return buildTopSellingSHItemCard();
                        }),
              ],
            ),
          ),
          Positioned.directional(textDirection: Directionality.of(context), top: 130, start: 0, end: 0, child: (!isLoading) ? buildOrderCard(context, orderCount) : buildOrderSHCard()),
        ],
      ),
    );
  }

  Container buildOrderCard(BuildContext context, TopSellingRevenueOrdCount orderCount) {
    var locale = AppLocalizations.of(context)!;
    return Container(
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
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(text: '${locale.orders}\n', style: Theme.of(context).textTheme.titleSmall),
                  TextSpan(text: (orderCount.totalOrders != null && orderCount.totalOrders != '') ? '${orderCount.totalOrders}' : '', style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 2)),
                ])),
            VerticalDivider(
              color: Colors.grey[400],
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(text: '${locale.revenue}\n', style: Theme.of(context).textTheme.titleSmall),
                  TextSpan(text: (orderCount.totalRevenue != null) ? '$apCurrency ${orderCount.totalRevenue!.toStringAsFixed(2)}' : '$apCurrency 0.0', style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 2)),
                ])),
            VerticalDivider(
              color: Colors.grey[400],
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(text: '${locale.pending}\n', style: Theme.of(context).textTheme.titleSmall),
                  TextSpan(text: (orderCount.pendingOrders != null) ? '${orderCount.pendingOrders}' : '0', style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 2)),
                ])),
          ],
        ),
      ),
    );
  }

  Widget buildOrderSHCard() {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.white,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
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
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                ],
              ),
              VerticalDivider(
                color: Colors.grey[400],
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
                ],
              ),
              VerticalDivider(
                color: Colors.grey[400],
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTopSellingItemCard(BuildContext context, String img, String? name, String sold, String price) {
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
              Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      img,
                      fit: BoxFit.fill,
                      width: 70,
                      height: 70,
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(style: Theme.of(context).textTheme.titleMedium, children: <TextSpan>[
                      TextSpan(text: '$name\n'),
                      TextSpan(text: '${locale.apparel}\n\n', style: Theme.of(context).textTheme.titleSmall),
                    ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(text: '$sold ${locale.sold}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0.5)),
                        ),
                        RichText(
                          text: TextSpan(style: Theme.of(context).textTheme.titleSmall!.copyWith(height: 1), children: <TextSpan>[
                            TextSpan(text: '${locale.revenue} '),
                            TextSpan(text: '$apCurrency $price', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14)),
                          ]),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTopSellingSHItemCard() {
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
