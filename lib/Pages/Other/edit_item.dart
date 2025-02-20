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
import 'package:vendor/beanmodel/productmodel/categorylist.dart';
import 'package:vendor/beanmodel/productmodel/storeprodcut.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key});

  @override
  EditItemPageState createState() => EditItemPageState();
}

class EditItemPageState extends State<EditItemPage> {
  var https = Client();
  StoreProductData? productData;
  late Varients productVarient;
  int? varaintId;
  bool isLoading = false;
  bool entered = false;
  List<CategoryListData?> categoryList = [];
  CategoryListData? catData;
  List<String?> tags = [];

  TextEditingController pDescC = TextEditingController();
  TextEditingController pPriceC = TextEditingController();
  TextEditingController pMrpC = TextEditingController();
  TextEditingController pQtyC = TextEditingController();
  TextEditingController pUnitC = TextEditingController();
  TextEditingController eanC = TextEditingController();

  // String catString = 'Select Item Category';

  String? _scanBarcode;

  EditItemPageState() {
    catData = CategoryListData('', 'Select Item Category', '', '', '', '', '', '', '');
    categoryList.add(catData);
  }

  @override
  void initState() {
    super.initState();
    getCategoryList(1);
  }

  @override
  void dispose() {
    https.close();
    super.dispose();
  }

  void scanProductCode(BuildContext context) async {
    var locale = AppLocalizations.of(context)!;
    await FlutterBarcodeScanner.scanBarcode("#ff6666", locale.cancel!, true, ScanMode.DEFAULT).then((value) {
      setState(() {
        _scanBarcode = value;
        eanC.text = _scanBarcode!;
      });
      debugPrint('scancode - $_scanBarcode');
    }).catchError((e) {});
  }

  void getCategoryList(dynamic pid) async {
    setState(() {
      isLoading = true;
    });
    https.post(storeVarientsListUri, body: {'product_id': '$pid'}).then((value) {
      if (value.statusCode == 200) {
        CategoryListMain categoryListMain = CategoryListMain.fromJson(jsonDecode(value.body));
        if ('${categoryListMain.status}' == '1') {
          setState(() {
            categoryList.clear();
            categoryList = List.from(categoryListMain.data!);
            catData = categoryList[0];
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
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    Map<String, dynamic>? argd = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (!entered) {
      setState(() {
        entered = true;
        productData = argd!['pData'];
        varaintId = argd['vid'];
        if (productData!.tags != null && productData!.tags!.isNotEmpty) {
          for (Tags tg in productData!.tags!) {
            tags.add(tg.tag);
          }
        }
        // pDescC.text = productData.varients
        int indexd = productData!.varients!.indexOf(Varients(varientId: varaintId));
        productVarient = productData!.varients![indexd];
        pDescC.text = '${productVarient.description}';
        pMrpC.text = productVarient.mrp!.toStringAsFixed(2);
        pPriceC.text = productVarient.price!.toStringAsFixed(2);
        pUnitC.text = '${productVarient.unit}';
        pQtyC.text = '${productVarient.quantity}';
        eanC.text = '${productVarient.ean}';
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale.updateItem!,
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
                      label: locale.updateItem)),
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
    https.post(storeVarientsUpdateUri, body: {
      'store_id': '${prefs.getInt('store_id')}',
      'varient_id': '${productVarient.varientId}',
      'quantity': pQtyC.text,
      'unit': pUnitC.text,
      'price': pPriceC.text,
      'mrp': pMrpC.text,
      'description': pDescC.text,
      'ean': eanC.text,
    }).then((value) {
      debugPrint('up - ${value.body}');
      var js = jsonDecode(value.body);
      if ('${js['status']}' == '1') {
        if(!context.mounted) return;
        Navigator.of(context).pop(true);
        setState(() {
          tags.clear();
          pDescC.clear();
          pMrpC.clear();
          pPriceC.clear();
          pQtyC.clear();
          pUnitC.clear();
          eanC.clear();
        });
        ToastContext().init(context);
        Toast.show(js['message'], duration: Toast.lengthShort, gravity: Toast.center);
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
