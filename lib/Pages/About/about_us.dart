import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
import 'package:vendor/Components/drawer.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/baseurl/baseurlg.dart';
import 'package:vendor/beanmodel/aboutus.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  dynamic title;
  dynamic content;
  // AboutUsData data;

  @override
  void initState() {
    super.initState();
    getWislist();
  }

  void getWislist() async {
    var url = appAboutusUri;
    var http = Client();
    http.get(url).then((value) {
      debugPrint('resp - ${value.body}');
      if (value.statusCode == 200) {
        AboutUsMain data1 = AboutUsMain.fromJsom(jsonDecode(value.body));
        debugPrint(data1.toString());
        if (data1.status == "1" || data1.status == 1) {
          setState(() {
            title = data1.data.title;
            content = data1.data.description;
          });
        }
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        title: Text(
          locale.aboutUs!,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Image.asset(
              'assets/icon.png',
              scale: 2.5,
              height: 280,
            ),
            Text(
              (title != null) ? '$title' : '',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[400]),
            ),
            const SizedBox(
              height: 20,
            ),
            (content != null)
                ? Html(
                    data: content,
                    style: {
                      "html": Style(
                        fontSize: FontSize.large,
//              color: Colors.white,
                      ),
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
