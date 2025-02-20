import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/custom_button.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/productmodel/categorylist.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {
  var https = http.Client();
  final List<String> _types = ['In Season', 'Regular'];
  String? _choosenTypes;
  bool isLoading = false;
  List<CategoryListData?> categoryList = [];
  CategoryListData? catData;
  List<String> tags = [];
  dynamic _scanBarcode;
  TextEditingController pNamec = TextEditingController();
  TextEditingController pDescC = TextEditingController();
  TextEditingController pPriceC = TextEditingController();
  TextEditingController pMrpC = TextEditingController();
  TextEditingController pQtyC = TextEditingController();
  TextEditingController pUnitC = TextEditingController();
  TextEditingController pTagsC = TextEditingController();
  TextEditingController eanC = TextEditingController();

  List<File?> imageList = [];
  File? productImage;

  File? _image;
  final picker = ImagePicker();

  String catString = 'Select Item Category';

  AddItemPageState() {
    imageList.add(File(''));
    catData = CategoryListData(
        '',
        'Select Item Category',
        '',
        '',
        '',
        '',
        '',
        '',
        '');
    categoryList.add(catData);
  }

  void scanProductCode(BuildContext context) async {
    var locale = AppLocalizations.of(context)!;
    await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", locale.cancel!, true, ScanMode.DEFAULT).then((value) {
      setState(() {
        _scanBarcode = value;
        eanC.text = _scanBarcode;
      });
      debugPrint('scancode - $_scanBarcode');
    }).catchError((e) {});
  }

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  @override
  void dispose() {
    https.close();
    super.dispose();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    https.get(catListUri).then((value) {
      if (value.statusCode == 200) {
        CategoryListMain categoryListMain = CategoryListMain.fromJson(
            jsonDecode(value.body));
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

  _imgFromCamera(bool isProductImage) async {
    var pathd = await getApplicationDocumentsDirectory();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        compressImageFile(
            _image!, '${pathd.path}/${DateTime.now()}.jpg', isProductImage);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  void compressImageFile(File file, String targetPath,
      bool isProductImage) async {
    try {
      debugPrint("testCompressAndGetFile");
      final result = await (FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 90,
      ) as FutureOr<File>);
      debugPrint(file.lengthSync().toString());
      debugPrint(result.lengthSync().toString());
      final bytes = result
          .readAsBytesSync()
          .lengthInBytes;
      final kb = bytes / 1024;
      debugPrint('kb $kb');
      if (kb > 1000) {
        setState(() {
          _image = null;
        });
        if(!mounted) return;
        ToastContext().init(context);
        Toast.show('upload image less then 1000 kb', gravity: Toast.center,
            duration: Toast.lengthShort);
      } else {
        setState(() {
          _image = result;
        });
        isProductImage ? productImage = File(_image!.path) : imageList.add(
            _image);
      }
    } catch (e) {
      debugPrint('');
    }
  }

  _imgFromGallery(bool isProductImage) async {
    var pathd = await getApplicationDocumentsDirectory();
    picker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          compressImageFile(
              _image!, '${pathd.path}/${DateTime.now()}.jpg', isProductImage);
        } else {
          debugPrint('No image selected.');
        }
      });
    }).catchError((e) { debugPrint(e); });
  }

  void _showPicker(context, bool isProductImage) {
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
                      _imgFromGallery(isProductImage);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(locale.camera!),
                  onTap: () {
                    _imgFromCamera(isProductImage);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale.addItem!,
          style: TextStyle(
            color: Theme
                .of(context)
                .colorScheme.surface,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              productImage != null
                  ? Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme
                      .of(context)
                      .primaryColor),
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image:
                    FileImage(
                      productImage!,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              )
                  : GestureDetector(
                onTap: () {
                  _showPicker(context, true);
                },
                child: const SizedBox(
                  //inner container
                  height: 250,
                  //height of inner container
                  width: double.infinity,
                  //width to 100% match to parent container.
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 60,
                          ),
                          Text('Add Product Image'),
                        ],
                      )),
                ),
              ),
              Container(
                height: 130,
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (index == 0) {
                            _showPicker(context, false);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            // !.withValues(alpha: index == 0 ? 1 : 0.9),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              // colorFilter: ColorFilter.mode(
                              //     Colors.grey[100]!.withValues(alpha: index == 0 ? 1 : 0.9),
                              //     index != 0 ? BlendMode.dst : BlendMode.clear),
                              image: (index == 0
                                  ? const AssetImage(
                                  'assets/ProductImages/lady finger.png')
                                  : FileImage(
                                imageList[index]!,
                              )) as ImageProvider<Object>,
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: index == 0
                              ? Icon(
                            Icons.camera_alt,
                            color: Theme
                                .of(context)
                                .primaryColor,
                            size: 30,
                          )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 8,
              ),
              buildHeading(context, locale.itemInfo!),
              EntryField(
                label: locale.productTitle,
                labelFontSize: 16,
                labelFontWeight: FontWeight.w400,
                controller: pNamec,
              ),
              Divider(
                thickness: 8,
                color: Colors.grey[100],
                height: 30,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: Text(
                        locale.itemCategory!,
                        style: TextStyle(fontSize: 13, color: kHintColor),
                      ),
                    ),
                    DropdownButton<CategoryListData>(
                      isExpanded: true,
                      value: catData,
                      underline: Container(
                        height: 1.0,
                        color: kMainTextColor,
                      ),
                      items: categoryList.map((values) {
                        return DropdownMenuItem<CategoryListData>(
                          value: values,
                          child: Text(values!.title),
                        );
                      }).toList(),
                      onChanged: (area) {
                        setState(() {
                          catData = area;
                        });
                      },
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 8,
                color: Colors.grey[100],
                height: 30,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: Text(
                        'TYPE',
                        style: TextStyle(fontSize: 13, color: kHintColor),
                      ),
                    ),
                    DropdownButton<String>(
                      hint: const Text('Choose type'),
                      isExpanded: true,
                      value: _choosenTypes,
                      underline: Container(
                        height: 1.0,
                        color: kMainTextColor,
                      ),
                      items: _types.map((values) {
                        return DropdownMenuItem<String>(
                          value: values,
                          child: Text(values),
                        );
                      }).toList(),
                      onChanged: (area) {
                        setState(() {
                          _choosenTypes = area;
                        });
                        // getSubCategoryList(area.category_id);
                      },
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 8,
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
              Divider(
                thickness: 8,
                color: Colors.grey[100],
                height: 30,
              ),
              buildHeading(context, locale.productTag1!),
              const SizedBox(
                height: 8,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: EntryField(
                            label: locale.productTag2,
                            hint: locale.productTag2,
                            labelFontSize: 16,
                            labelFontWeight: FontWeight.w400,
                            controller: pTagsC,
                          )),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (pTagsC.text.isNotEmpty) {
                            int idd = tags.indexOf(pTagsC.text.toUpperCase());
                            if (idd < 0) {
                              setState(() {
                                tags.add(pTagsC.text.toUpperCase());
                                pTagsC.clear();
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                    tags[index],
                                    textAlign: TextAlign.start,
                                  )),
                              IconButton(
                                icon: const Icon(Icons.delete_forever),
                                onPressed: () {
                                  setState(() {
                                    tags.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      })
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
                    if (pNamec.text.isNotEmpty) {
                      if (pDescC.text.isNotEmpty) {
                        if (pPriceC.text.isNotEmpty) {
                          if (pMrpC.text.isNotEmpty) {
                            if (pQtyC.text.isNotEmpty) {
                              if (pUnitC.text.isNotEmpty) {
                                if (_choosenTypes != null) {
                                  if (catData!.title != null &&
                                      '${catData!.title}' != catString) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (_image != null ||
                                        (productImage != null &&
                                            (productImage.toString().contains(
                                                '.jpg') ||
                                                productImage.toString()
                                                    .contains('.png') ||
                                                productImage.toString()
                                                    .contains('.jpeg')))) {
                                      String fid = _image!
                                          .path
                                          .split('/')
                                          .last;
                                      if (fid.isNotEmpty) {
                                        addProductWithImage(fid);
                                      } else {
                                        addProduct();
                                      }
                                    } else {
                                      addProduct();
                                    }
                                  }
                                } else {
                                  ToastContext().init(context);
                                  Toast.show(
                                      'Choose type', gravity: Toast.center,
                                      duration: Toast.lengthShort);
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  label: locale.addItem)),
        ],
      ),
    );
  }

  Padding buildHeading(BuildContext context, String heading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
      child: Text(heading, style: Theme
          .of(context)
          .textTheme
          .titleSmall!
          .copyWith(fontWeight: FontWeight.w500)),
    );
  }

  void addProductWithImage(String fid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<MultipartFile> newList = [];

    for (var i = 0; i < imageList.length; i++) {
      if (imageList.isNotEmpty && imageList[i]!.path != '') {
        MultipartFile tFile = await MultipartFile.fromFile(imageList[i]!.path);
        newList.add(tFile);
      }
    }
    var dio = Dio();
    var formData = FormData.fromMap({
      'store_id': '${prefs.getInt('store_id')}',
      'cat_id': '${catData!.catId}',
      'product_name': pNamec.text,
      'quantity': pQtyC.text,
      'unit': pUnitC.text,
      'price': pPriceC.text,
      'mrp': pMrpC.text,
      'description': pDescC.text,
      'ean': eanC.text,
      'type': _choosenTypes,
      'tags': tags.toString(),
      'product_image': _image != null ? await MultipartFile.fromFile(
          _image!.path) : null,
      'images': newList,
    });

    await dio
        .post(storeProductsAddUri.toString(),
        data: formData,
        options: Options(
        ))
        .then((response) {
      debugPrint('success');
      if(!mounted) return;
      ToastContext().init(context);
      Toast.show(response.data['message'], gravity: Toast.center,
          duration: Toast.lengthShort);
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void addProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    https.post(storeProductsAddUri, body: {
      'store_id': '${prefs.getInt('store_id')}',
      'tags': tags.toString(),
      'cat_id': '${catData!.catId}',
      'product_name': pNamec.text,
      'quantity': pQtyC.text,
      'unit': pUnitC.text,
      'price': pPriceC.text,
      'mrp': pMrpC.text,
      'description': pDescC.text,
      'ean': eanC.text,
      'product_image': '',
      'type': _choosenTypes
    }).then((value) {
      var jsonData = jsonDecode(value.body);
      if ('${jsonData['status']}' == '1') {
        setState(() {
          pNamec.clear();
          tags.clear();
          pDescC.clear();
          pMrpC.clear();
          pPriceC.clear();
          pQtyC.clear();
          pUnitC.clear();
          eanC.clear();
        });
      }
      if(!mounted) return;
      ToastContext().init(context);
      Toast.show(jsonData['message'], gravity: Toast.center,
          duration: Toast.lengthShort);
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
