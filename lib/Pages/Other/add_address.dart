import 'package:flutter/material.dart';
import 'package:vendor/Components/custom_button.dart';
import 'package:vendor/Locale/locales.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale.addAddress!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        actions: const [
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/map.png',
            fit: BoxFit.fill,
            width: 400,
          ),
          const Positioned(
            top: 300,
            left: 160,
            child: Icon(
              Icons.location_on,
              color: Color(0xFF39c526),
              size: 32,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF39c526),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('1124, Patestine Street, Jackson Tower,\nNear City Garden, New York, USA'),
                    ],
                  ),
                ),
                CustomButton(
                  onTap: () {},
                  label: locale.saveAddress,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
