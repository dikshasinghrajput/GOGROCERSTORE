import 'package:flutter/material.dart';

class ImageDetail extends StatefulWidget {
  final String? url;
  const ImageDetail(this.url, {super.key});

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Scaffold(
          appBar: AppBar(),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(widget.url!)),
              )),
        ));
  }
}
