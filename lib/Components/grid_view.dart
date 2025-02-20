import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/beanmodel/productmodel/adminprodcut.dart';
import 'package:vendor/beanmodel/productmodel/storeprodcut.dart';

GridView buildGridView(List<StoreProductData> listName, {bool favourites = false, void Function(int index, String type)? callBack, void Function(StoreProductData pdData, String type, int? pvid)? update, void Function(int pid)? addVaraient, void Function(StoreProductData pdData, String type, int? varientId)? updateStock}) {
  return GridView.builder(
      padding: const EdgeInsets.all(20.0),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: listName.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemBuilder: (context, index) {
        return buildProductCard(context, listName[index],
            favourites: favourites,
            callBack: (id, type) {
              callBack!(id, type);
            },
            update: (productdatad, type, vorpid) {
              update!(productdatad, type, vorpid);
            },
            addVaraient: (id) => addVaraient!(id),
            updateStock: (productdatad, type, vorpid) {
              updateStock!(productdatad, type, vorpid);
            });
      });
}

GridView buildGridAdminView(List<StoreProductM> listName, {bool favourites = false, void Function(int index, String type)? callBack, void Function(StoreProductM pdData, String type, int? pvid)? update, void Function(int pid)? addVaraient}) {
  return GridView.builder(
      padding: const EdgeInsets.all(20.0),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: listName.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemBuilder: (context, index) {
        return buildProductAdminCard(context, listName[index], favourites: favourites, update: (pData, type, pid) {
          update!(pData, type, pid);
        });
      });
}

GridView buildGridSHView() {
  return GridView.builder(
      padding: const EdgeInsets.all(20.0),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemBuilder: (context, index) {
        return buildProductSHCard(context);
      });
}

Widget buildProductSHCard(BuildContext context) {
  return Shimmer(
    duration: const Duration(seconds: 3),
    color: Colors.white,
    enabled: true,
    direction: const ShimmerDirection.fromLTRB(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.width / 2.5,
                child: Container(
                  color: Colors.grey[300],
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 10,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 10,
                width: 30,
                color: Colors.grey[300],
              ),
              Container(
                height: 10,
                width: 30,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildProductCard(BuildContext context, StoreProductData productData,
    {bool favourites = false, void Function(int index, String type)? callBack, void Function(StoreProductData pdData, String type, int? varientId)? update, void Function(int pid)? addVaraient, void Function(StoreProductData pdData, String type, int? varientId)? updateStock}) {
  var locale = AppLocalizations.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: CachedNetworkImage(
            imageUrl: productData.productImage,
            placeholder: (context, url) => Align(
              widthFactor: 50,
              heightFactor: 50,
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset('assets/icon.png'),
          ),
        ),
      ),
      Visibility(visible: (productData.varients!.isNotEmpty), child: const SizedBox(height: 4)),
      productData.varients!.isNotEmpty ? Text('${productData.varients![0].quantity} ${productData.varients![0].unit}', style: TextStyle(color: Colors.grey[500], fontSize: 13)) : const SizedBox(),
      // Visibility(visible: (productData.varients.length > 0), child: Text('${productData.varients[0].quantity} ${productData.varients[0].unit}', style: TextStyle(color: Colors.grey[500], fontSize: 13))),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(productData.productName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500))),
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      locale!.product!,
                                      style: TextStyle(color: kMainColor, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  update!(productData, 'product', productData.productId);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(border: Border.all(color: kMainColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        locale.updateproduct!,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const Icon(Icons.open_in_new),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    updateStock!(productData, 'product', productData.productId);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: kMainColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locale.updatestock!,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const Icon(Icons.open_in_new),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  callBack!(int.parse('${productData.productId}'), 'product');
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(border: Border.all(color: kMainColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${locale.delete} ${locale.product}',
                                        style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                                      ),
                                      const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (productData.varients != null && productData.varients!.isNotEmpty),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        locale.variant!,
                                        style: TextStyle(color: kMainColor, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (productData.varients != null && productData.varients!.isNotEmpty),
                              child: ListView.builder(
                                  itemCount: productData.varients!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(border: Border.all(color: kMainColor)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${productData.varients![index].quantity} ${productData.varients![index].unit}',
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    update!(productData, 'variant', int.parse('${productData.varients![index].varientId}'));
                                                  },
                                                  behavior: HitTestBehavior.opaque,
                                                  child: Column(
                                                    children: [
                                                      const Icon(Icons.open_in_new),
                                                      Text(
                                                        locale.update!,
                                                        style: const TextStyle(fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    callBack!(int.parse('${productData.varients![index].varientId}'), 'variant');
                                                  },
                                                  behavior: HitTestBehavior.opaque,
                                                  child: Column(
                                                    children: [
                                                      const Icon(
                                                        Icons.delete,
                                                        color: Colors.redAccent,
                                                      ),
                                                      Text(
                                                        locale.delete!,
                                                        style: const TextStyle(fontSize: 16, color: Colors.redAccent),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shadowColor: WidgetStateProperty.all(kMainColor),
                                  overlayColor: WidgetStateProperty.all(kMainColor),
                                  backgroundColor: WidgetStateProperty.all(kMainColor),
                                  foregroundColor: WidgetStateProperty.all(kMainColor),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  addVaraient!(int.parse('${productData.productId}'));
                                },
                                child: Text(
                                  locale.addVarient!,
                                  style: TextStyle(color: kTextColor),
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Image.asset(
                'assets/more.png',
                height: 20,
                width: 20,
              ))
        ],
      ),
    ],
  );
}

Widget buildProductAdminCard(BuildContext context, StoreProductM productData, {bool favourites = false, void Function(int index, String type)? callBack, void Function(StoreProductM pdData, String type, int? varientId)? update, void Function(int pid)? addVaraient}) {
  var locale = AppLocalizations.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: CachedNetworkImage(
            imageUrl: productData.productImage,
            placeholder: (context, url) => Align(
              widthFactor: 50,
              heightFactor: 50,
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset('assets/icon.png'),
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text('${productData.quantity} ${productData.unit}', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(productData.productName, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.w500))),
          Visibility(
            visible: ('${productData.approved}' == '0'),
            child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        locale!.product!,
                                        style: TextStyle(color: kMainColor, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    update!(productData, 'product', productData.productId);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: kMainColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locale.updateproduct!,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const Icon(Icons.open_in_new),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    callBack!(int.parse('${productData.productId}'), 'product');
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: kMainColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${locale.delete} ${locale.product}',
                                          style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                                        ),
                                        const Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 80,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Image.asset(
                  'assets/more.png',
                  height: 20,
                  width: 20,
                )),
          )
        ],
      ),
    ],
  );
}

Container buildRating(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 1.5, bottom: 1.5, left: 4, right: 3),
    //width: 30,
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Text(
          "4.2",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 10),
        ),
        const SizedBox(
          width: 1,
        ),
        Icon(
          Icons.star,
          size: 10,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    ),
  );
}
