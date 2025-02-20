import 'dart:convert';

// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart' as BluetoothP;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as child_image;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Pages/Other/order_info.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/appinfomodel.dart';
import 'package:vendor/beanmodel/orderbean/todayorderbean.dart';
import 'package:vendor/beanmodel/util/invoice.dart';

class TodayOrder extends StatefulWidget {
  const TodayOrder({super.key});

  @override
  State<TodayOrder> createState() => _TodayOrderState();
}

class _TodayOrderState extends State<TodayOrder> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _deviceList = [];
  PrinterBluetooth? _device;
  String tips = 'no device connect';
  List<TodayOrderMain> newOrders = [];
  bool isLoading = false;
  var http = Client();

  dynamic apCurrency;

  @override
  void initState() {
    super.initState();
    initBluetooth();
    hitAppInfo();
  }

  @override
  void dispose() {
    _onDisconnect();
    http.close();
    super.dispose();
  }

  Future<void> initBluetooth() async {
    printerManager.startScan(const Duration(seconds: 4));
    printerManager.scanResults.listen((printers) async {
      debugPrint('printer');
      setState(() {
        debugPrint(printers.toList().toString());
        _deviceList.clear();
        _deviceList = List.from(printers);
        debugPrint(_deviceList.toString());
      });
    });
  }

  void _onConnect(cartId, AppLocalizations locale) async {
    if (_device != null) {
      printerManager.selectPrinter(_device!);
      getInvoice(cartId, locale);
    } else {
      setState(() {
        tips = 'please select device';
      });
      debugPrint('please select device');
    }
  }

  void _onDisconnect() async {
    printerManager.stopScan();
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
    http.post(storetodayOrdersUri, body: {'store_id': '${prefs.getInt('store_id')}'}).then((value) {
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
          ? ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: const ScrollPhysics(),
                    itemCount: newOrders.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildCompleteCard(context, newOrders[index]);
                    }),
              ],
            )
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

  CircleAvatar buildStatusIcon(IconData icon, {bool disabled = false}) => CircleAvatar(
      backgroundColor: !disabled ? const Color(0xff222e3e) : Colors.grey[300],
      child: Icon(
        icon,
        size: 20,
        color: !disabled ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
      ));

  GestureDetector buildCompleteCard(BuildContext context, TodayOrderMain mainP) {
    var locale = AppLocalizations.of(context);
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
            buildPrintRow(context, locale, cartId: '${mainP.cartId}'),
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

  Container buildPrintRow(BuildContext context, AppLocalizations? locale, {double borderRadius = 8, dynamic cartId}) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
        color: Colors.grey[100],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(kMainColor),
          ),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext contextd) {
                  return AlertDialog(
                    title: Text(locale.headingAlert1!),
                    content: _deviceList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _deviceList.length,
                            itemBuilder: (cntxt, index) {
                              return buildBluetoothCard(contextd, _deviceList[index], locale,cartId);
                            })
                        : const SizedBox(),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          shadowColor: WidgetStateProperty.all(Colors.transparent),
                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                          backgroundColor: WidgetStateProperty.all(Colors.transparent),
                          foregroundColor: WidgetStateProperty.all(Colors.transparent),
                          shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        child: Text(
                          locale.close!,
                          style: TextStyle(color: kMainColor),
                        ),
                        onPressed: () => Navigator.pop(contextd),
                      ),
                    ],
                  );
                });
          },
          child: Text(locale.printinvoice!),
        ),
      ),
    );
  }

  void getInvoice(dynamic cartId, AppLocalizations locale) async {
    http.post(getInvoiceUri, body: {'cart_id': cartId}).then((value) {
      if (value.statusCode == 200) {
        Invoice invoice = Invoice.fromJson(jsonDecode(value.body));
        if ('${invoice.status}' == '1') {
          printOrCreateInvoice(invoice, locale).then((pTicket) async {
            final PosPrintResult res = await printerManager.printTicket(pTicket);
            debugPrint('Print result: ${res.msg}');
          });
        }
      }
    }).catchError((e) {});
  }

  Future<dynamic> printOrCreateInvoice(Invoice invoice, AppLocalizations locale) async {
    PaperSize paperSize = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    Generator ticket = Generator(paperSize, profile);
    List<int> bytes1 = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ByteData data = await rootBundle.load('assets/icon.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    final child_image.Image image = child_image.decodeImage(bytes)!;
    bytes1 += ticket.image(image);

    bytes1 += ticket.text(prefs.getString('app_name')!,
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes1 += ticket.text('${invoice.address}', styles: const PosStyles(align: PosAlign.center));
    bytes1 += ticket.text('${invoice.city} (${invoice.pincode})', styles: const PosStyles(align: PosAlign.center));
    bytes1 += ticket.text('Tel: ${invoice.number}', styles: const PosStyles(align: PosAlign.center));
    bytes1 += ticket.hr();
    bytes1 += ticket.row([
      PosColumn(text: '#', width: 1),
      PosColumn(text: locale.invoice1h!, width: 7),
      PosColumn(text: locale.invoice2h!, width: 1),
      PosColumn(text: locale.invoice3h!, width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: locale.invoice4h!, width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);
    List<OrderDetails> orderDetaisl = List.from(invoice.orderDetails!);
    int it = 1;
    for (OrderDetails details in orderDetaisl) {
      bytes1 += ticket.row([
        PosColumn(text: '$it', width: 1),
        PosColumn(text: '${details.productName} (${details.quantity} ${details.unit})', width: 7),
        PosColumn(text: '${details.qty}', width: 1),
        PosColumn(text: details.price!.toStringAsFixed(2), width: 2, styles: const PosStyles(align: PosAlign.right)),
        PosColumn(text: (details.price! * double.parse('${details.qty}')).toStringAsFixed(2), width: 2, styles: const PosStyles(align: PosAlign.right)),
      ]);
      it++;
    }

    bytes1 += ticket.hr();

    bytes1 += ticket.row([
      PosColumn(
          text: locale.invoice4h!,
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: '$apCurrency ${(invoice.totalPrice! + invoice.deliveryCharge!).toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    bytes1 += ticket.hr(ch: '=', linesAfter: 1);
    bytes1 += ticket.row([
      PosColumn(text: locale.invoice5h!, width: 7, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(text: '$apCurrency ${invoice.totalPrice!.toStringAsFixed(2)}', width: 5, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);
    bytes1 += ticket.row([
      PosColumn(text: locale.invoice6h!, width: 7, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(text: '$apCurrency ${invoice.deliveryCharge!.toStringAsFixed(2)}', width: 5, styles: const PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    bytes1 += ticket.feed(2);
    bytes1 += ticket.text(locale.invoice7h!, styles: const PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes1 += ticket.text(timestamp, styles: const PosStyles(align: PosAlign.center), linesAfter: 2);
    bytes1 += ticket.feed(2);
    bytes1 += ticket.cut();
    return bytes1;
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

  Padding buildAmountRow(String name, String price, {FontWeight fontWeight = FontWeight.w500}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: fontWeight),
          ),
          const Spacer(),
          Text(
            price,
            style: TextStyle(fontWeight: fontWeight),
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

  Container buildBluetoothCard(BuildContext context, PrinterBluetooth bt, AppLocalizations locale, cartId) {
    var locale = AppLocalizations.of(context)!;
    return Container(
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
              ClipRRect(borderRadius: BorderRadius.circular(8), child: const Icon(Icons.bluetooth_audio_sharp)),
              const SizedBox(
                width: 10,
              ),
              RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.titleMedium, children: <TextSpan>[
                TextSpan(text: '${bt.name}\n'),
                TextSpan(text: '${locale.apparel}\n\n', style: Theme.of(context).textTheme.titleSmall),
                TextSpan(text: '${bt.address} ${locale.sold}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0.5)),
              ])),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _device = bt;
                  });
                  Navigator.of(context);
                  _onConnect(cartId,locale);
                },
                style: ButtonStyle(
                  backgroundColor:WidgetStateProperty.all(kMainColor),
                  textStyle: WidgetStateProperty.all(TextStyle(
                    color: kWhiteColor,
                  ))
                ),
                child: Text(locale.connect!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
