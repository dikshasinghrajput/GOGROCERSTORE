import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/mapsection/googlemapkey.dart';
import 'package:vendor/beanmodel/mapsection/latlng.dart';
import 'package:vendor/beanmodel/mapsection/mapboxbean.dart';
import 'package:vendor/beanmodel/mapsection/mapbybean.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchLocationState();
  }
}

class SearchLocationState extends State<SearchLocation> {
  var http = Client();
  bool isLoading = false;
  bool isDispose = false;
  GooglePlace? places;
  GeoCoding? placesSearch;
  List<SearchResult> searchPredictions = [];
  List<MapBoxPlace> placePred = [];
  late SearchResult pPredictions;
  late MapBoxPlace mapboxPredictions;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() async {
      if(!isDispose){
        if (searchController.text.isNotEmpty) {
          if (places != null) {
            await places!.search.getTextSearch(searchController.text).then((value) {
              if (searchController.text.isNotEmpty && mounted) {
                setState(() {
                  searchPredictions.clear();
                  searchPredictions = List.from(value!.results!);
                });
              } else {
                if(mounted){
                  setState(() {
                    searchPredictions.clear();
                  });
                }
              }
            }).catchError((e) {
              if(mounted){
                setState(() {
                  searchPredictions.clear();
                });
              }
            });
          } else if (placesSearch != null) {
            placesSearch!.getPlaces(searchController.text).then((value) {
              if (searchController.text.isNotEmpty && mounted) {
                setState(() {
                  if(value.success != null) {
                    placePred.clear();
                    placePred = value.success!;
                    debugPrint(value.success?[0].placeName);
                    debugPrint(
                        '${value.success![0].geometry!.coordinates.lat} ${value.success![0].geometry!.coordinates.long}');
                  }
                });
              } else {
                if(mounted){
                  setState(() {
                    placePred.clear();
                  });
                }
              }
            }).catchError((e) {
              if(mounted){
                setState(() {
                  placePred.clear();
                });
              }
            });
          }
        }
        else {
          if (places != null && mounted) {
            setState(() {
              searchPredictions.clear();
            });
          } else if (placesSearch != null && mounted) {
            setState(() {
              placePred.clear();
            });
          }
        }
      }
    });
    getMapbyApi();
  }

  void getMapbyApi() async {
    setState(() {
      isLoading = true;
    });
    http.get(mapbyUri).then((value) {
      if (value.statusCode == 200) {
        MapByKey googleMapD = MapByKey.fromJson(jsonDecode(value.body));
        if ('${googleMapD.status}' == '1') {
          if ('${googleMapD.data!.mapbox}' == '1') {
            getMapBoxKey();
          } else if ('${googleMapD.data!.googleMap}' == '1') {
            getGoogleMapKey();
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void getGoogleMapKey() async {
    http.get(googleMapUri).then((value) {
      if (value.statusCode == 200) {
        GoogleMapKey googleMapD = GoogleMapKey.fromJson(jsonDecode(value.body));
        if ('${googleMapD.status}' == '1') {
          setState(() {
            places = GooglePlace('${googleMapD.data!.mapApiKey}');
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

  void getMapBoxKey() async {
    http.get(mapboxUri).then((value) {
      if (value.statusCode == 200) {
        MapBoxApiKey googleMapD = MapBoxApiKey.fromJson(jsonDecode(value.body));
        if ('${googleMapD.status}' == '1') {
          setState(() {
            placesSearch = GeoCoding(
              apiKey: '${googleMapD.data!.mapboxApi}',
              limit: 5,
            );
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
  void dispose() {
    http.close();
    isDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: Text(
            locale.searchyourlocation!,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                // .copyWith(color: kMainTextColor.withValues(alpha: 0.8)),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 52,
            margin: const EdgeInsets.only(left: 20,right: 20),
            decoration: BoxDecoration(
                color: kWhiteColor, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              readOnly: isLoading,
              decoration: InputDecoration(
                hintText: locale.searchyourlocation,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kHintColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kHintColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kHintColor, width: 1),
                ),
              ),

              controller: searchController,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                children: [
                  Visibility(
                    visible: (searchPredictions.isNotEmpty),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: kWhiteColor,
                      margin: const EdgeInsets.only(top: 5),
                      padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: ListView.separated(
                        itemCount: searchPredictions.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                pPredictions = searchPredictions[index];
                              });
                              Navigator.pop(
                                  context,
                                  BackLatLng(pPredictions.geometry!.location!.lat,
                                      pPredictions.geometry!.location!.lng,searchPredictions[index].formattedAddress));
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height:15,
                                  width:15,
                                  child: Image.asset(
                                    'images/map_pin.png',
                                    scale: 3,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${searchPredictions[index].formattedAddress}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 1,
                            color: kLightTextColor,
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (placePred.isNotEmpty),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: kWhiteColor,
                      margin: const EdgeInsets.only(top: 5),
                      padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: ListView.separated(
                        itemCount: placePred.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                mapboxPredictions = placePred[index];
                              });
                              Navigator.pop(
                                  context,
                                  BackLatLng(
                                      mapboxPredictions.geometry!.coordinates.long,
                                      mapboxPredictions.geometry!.coordinates.lat,placePred[index].placeName));
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height:15,
                                  width:15,
                                  child: Image.asset(
                                    'images/map_pin.png',
                                    scale: 3,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${placePred[index].placeName}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 1,
                            color: kLightTextColor,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}