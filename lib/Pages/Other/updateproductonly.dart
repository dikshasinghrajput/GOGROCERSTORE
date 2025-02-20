import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/custom_button.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/productmodel/storeprodcut.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key});

  @override
  UpdateProductPageState createState() => UpdateProductPageState();
}

class UpdateProductPageState extends State<UpdateProductPage> {
  StoreProductData? productData;
  var https = http.Client();
  bool isLoading = false;
  List<String> tags = [];
  final List<String> _types = ['In Season', 'Regular'];
  String? _choosenTypes;

  TextEditingController pNamec = TextEditingController();
  TextEditingController pTagsC = TextEditingController();
  TextEditingController eanC = TextEditingController();

  List<File?> imageList = [];
  File? _imageFile;

  File? _image;
  final picker = ImagePicker();
  int? prodId;

  String? productImage;

  UpdateProductPageState() {
    imageList.add(File(''));
  }

  bool entered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    https.close();
    super.dispose();
  }

  _imgFromCamera(bool isProductImage) async {
    var pathd = await getApplicationDocumentsDirectory();

    await picker.pickImage(source: ImageSource.camera).then((pickedFile) {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        compressImageFile(_image!, '${pathd.path}/${DateTime.now()}.jpg', isProductImage);
      } else {
        debugPrint('No image selected.');
      }
    }).catchError((e) { debugPrint(e); });
  }

  _imgFromGallery(bool isProductImage) async {
    var pathd = await getApplicationDocumentsDirectory();

    picker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        compressImageFile(_image!, '${pathd.path}/${DateTime.now()}.jpg', isProductImage);
      } else {
        debugPrint('No image selected.');
      }
    }).catchError((e) { debugPrint(e); });
  }

  void compressImageFile(File file, String targetPath, bool isProductImage) async {
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
        Toast.show('upload image less then 1000 kb', gravity: Toast.center, duration: Toast.lengthShort);
      } else {
        setState(() {
          _image = result;
          isProductImage ? _imageFile = _image : imageList.add(_image);
        });
      }
    } catch (e) {
      debugPrint('');
    }
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
    Map<String, dynamic>? argd = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (!entered) {
      setState(() {
        entered = true;
        productData = argd!['pData'];
        prodId = productData!.productId;
        pNamec.text = productData!.productName;
        _choosenTypes = productData!.type;
        if (productData!.tags != null && productData!.tags!.isNotEmpty) {
          for (Tags tg in productData!.tags!) {
            tags.add(tg.tag.toString().replaceAll('[', '').replaceAll(']', ''));
          }
        }
        productImage = productData!.productImage;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale.addItem!,
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
              const SizedBox(
                height: 8,
              ),
              buildHeading(context, locale.pimage1!),
              GestureDetector(
                onTap: () {
                  _showPicker(context, true);
                },
                child: Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        )
                      : productImage != null && (productImage.toString().contains('.jpg') || productImage.toString().contains('.png') || productImage.toString().contains('.jpeg'))
                          ? Image.network(
                              productImage ?? '',
                              fit: BoxFit.cover,
                            )
                          : GestureDetector(
                              onTap: () {
                                _showPicker(context, true);
                              },
                              child: const SizedBox(
                                //inner container
                                height: 250, //height of inner container
                                width: double.infinity, //width to 100% match to parent container.
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
                ),
              ),
              Divider(
                thickness: 8,
                color: Colors.grey[100],
                height: 30,
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
                              //   Colors.grey[100]!.withValues(alpha: index == 0 ? 1 : 0.9),
                              //   index != 0 ? BlendMode.dst : BlendMode.clear,
                              // ),
                              image: (index == 0 ? const AssetImage('assets/ProductImages/lady finger.png') : FileImage(imageList[index]!)) as ImageProvider<Object>,
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: index == 0
                              ? Icon(
                                  Icons.camera_alt,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }),
              ),
              Divider(
                thickness: 8,
                color: Colors.grey[100],
                height: 30,
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
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                      child: Text(
                        'TYPE',
                        style: TextStyle(fontSize: 13, color: kHintColor),
                      ),
                    ),
                    DropdownButton<String>(
                      hint: Text(productData != null && productData!.type != null && productData!.type!.isNotEmpty ? productData!.type! : 'Choose type'),
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
                          setState(() {
                            isLoading = true;
                          });
                          if (_imageFile != null || (imageList.isNotEmpty && imageList[0]!.path != '')) {
                            updateProductWithImage(context);
                          } else {
                            updateProduct(context);
                          }
                        }
                      },
                      //},
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

  void updateProductWithImage(BuildContext context) async {
    List<MultipartFile> newList = [];

    for (var i = 0; i < imageList.length; i++) {
      if (imageList.isNotEmpty && imageList[i]!.path != '') {
        MultipartFile tFile = await MultipartFile.fromFile(imageList[i]!.path);
        newList.add(tFile);
      }
    }
    var dio = Dio();
    var formData = FormData.fromMap({
      'product_id': '$prodId',
      'product_name': pNamec.text,
      'type': '$_choosenTypes',
      'product_image': _imageFile != null ? await MultipartFile.fromFile(_imageFile!.path) : null,
      'images': newList,
      'tags': tags.toString(),
    });

    await dio
        .post(
      storeProductsUpdateUri.toString(),
      data: formData,
      options: Options(),
    )
        .then((response) {
      debugPrint('success');

      setState(() {
        isLoading = false;
      });
      if(!context.mounted) return;
      ToastContext().init(context);
      Toast.show(response.data['message'], gravity: Toast.center, duration: Toast.lengthShort);
    }).catchError((e) {
      debugPrint(e.toString());
    });
    setState(() {
      isLoading = false;
    });
  }

  void updateProduct(BuildContext context) async {
    https.post(storeProductsUpdateUri, body: {
      'product_id': '$prodId',
      'product_name': pNamec.text,
      'tags': tags.toString(),
      'product_image': '',
      'type': _choosenTypes,
    }).then((value) {
      debugPrint(value.body);
      var jsonData = jsonDecode(value.body);
      if(!context.mounted) return;
      if ('${jsonData['status']}' == '1') {
        Navigator.of(context).pop(true);
      }
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
