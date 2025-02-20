import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/custom_button.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/baseurl/baseurlg.dart';

class AddVarientPage extends StatefulWidget {
  const AddVarientPage({super.key});

  @override
  AddVarientPageState createState() => AddVarientPageState();
}

class AddVarientPageState extends State<AddVarientPage> {
  var https = Client();
  bool isLoading = false;
  bool entered = false;

  TextEditingController pDescC = TextEditingController();
  TextEditingController pPriceC = TextEditingController();
  TextEditingController pMrpC = TextEditingController();
  TextEditingController pQtyC = TextEditingController();
  TextEditingController pUnitC = TextEditingController();
  TextEditingController eanC = TextEditingController();

  dynamic prodcutid;

  String? _scanBarcode;

  @override
  void initState() {
    super.initState();
  }

  void scanProductCode(BuildContext context) async {
    await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT).then((value) {
      setState(() {
        _scanBarcode = value;
        eanC.text = _scanBarcode!;
      });
      debugPrint('scancode - $_scanBarcode');
    }).catchError((e) {});
  }

  @override
  void dispose() {
    https.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    Map<String, dynamic>? argd = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (!entered) {
      setState(() {
        entered = true;
        prodcutid = argd!['pId'];
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale.addVarient!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Divider(
                thickness: 2,
                color: Colors.grey[100],
                height: 30,
              ),
              buildHeading(context, locale.description!),
              EntryField(
                maxLines: 4,
                label: locale.briefYourProduct,
                labelFontSize: 16,
                labelFontWeight: FontWeight.w400,
                controller: pDescC,
              ),
              Divider(
                thickness: 8,
                color: Colors.grey[100],
                height: 30,
              ),
              buildHeading(context, locale.pricingStock!),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                      child: EntryField(
                    label: locale.sellProductPrice,
                    hint: locale.sellProductPrice,
                    labelFontSize: 16,
                    labelFontWeight: FontWeight.w400,
                    controller: pPriceC,
                  )),
                  Expanded(
                      child: EntryField(
                    label: locale.sellProductMrp,
                    hint: locale.sellProductMrp,
                    labelFontSize: 16,
                    labelFontWeight: FontWeight.w400,
                    controller: pMrpC,
                  )),
                ],
              ),
              Divider(
                thickness: 8,
                color: Colors.grey[100],
                height: 30,
              ),
              buildHeading(context, locale.qntyunit!),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                      child: EntryField(
                    label: locale.qnty1,
                    hint: locale.qnty2,
                    labelFontSize: 16,
                    labelFontWeight: FontWeight.w400,
                    controller: pQtyC,
                  )),
                  Expanded(
                      child: EntryField(
                    label: locale.unit1,
                    hint: locale.unit2,
                    labelFontSize: 16,
                    labelFontWeight: FontWeight.w400,
                    controller: pUnitC,
                  )),
                ],
              ),
              Divider(
                thickness: 8,
                color: Colors.grey[100],
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: EntryField(
                    label: locale.ean1,
                    hint: locale.ean2,
                    labelFontSize: 16,
                    labelFontWeight: FontWeight.w400,
                    controller: eanC,
                  )),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      scanProductCode(context);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: isLoading
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    )
                  : CustomButton(
                      onTap: () {
                        if (pDescC.text.isNotEmpty) {
                          if (pPriceC.text.isNotEmpty) {
                            if (pMrpC.text.isNotEmpty) {
                              if (pQtyC.text.isNotEmpty) {
                                if (pUnitC.text.isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  addProduct(context);
                                }
                              }
                            }
                          }
                        }
                      },
                      label: locale.addVarient)),
        ],
      ),
    );
  }

  Padding buildHeading(BuildContext context, String heading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
      child: Text(heading, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500)),
    );
  }

  void addProduct(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    https.post(storeVarientsAddUri, body: {
      'store_id': '${prefs.getInt('store_id')}',
      'product_id': '$prodcutid',
      'quantity': pQtyC.text,
      'unit': pUnitC.text,
      'price': pPriceC.text,
      'mrp': pMrpC.text,
      'description': pDescC.text,
      'ean': eanC.text,
    }).then((value) {
      var jsonData = jsonDecode(value.body);
      if ('${jsonData['status']}' == '1') {
        if(!context.mounted) return;
        Navigator.of(context).pop(true);
        setState(() {
          pDescC.clear();
          pMrpC.clear();
          pPriceC.clear();
          pQtyC.clear();
          pUnitC.clear();
          eanC.clear();
        });
      }
      if(!context.mounted) return;
      ToastContext().init(context);
      Toast.show(jsonData['message'], gravity: Toast.center, duration: Toast.lengthShort);
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
