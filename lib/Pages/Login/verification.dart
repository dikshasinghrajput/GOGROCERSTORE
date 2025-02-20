
import 'package:flutter/material.dart';
import 'package:vendor/Components/custom_button.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Routes/routes.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});


  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.verification!,style: TextStyle(color:Theme.of(context).colorScheme.surface)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 48),
            child: Text(
              locale.pleaseEnterVerificationCodeSentGivenNumber!,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 28.0, left: 18, right: 18, bottom: 4),
            child: Text(
              locale.enterVerificationCode!,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w500),
            ),
          ),
          EntryField(
            hint: locale.enterVerificationCode,
          ),
          const Spacer(),
          CustomButton(
            onTap: (){
              Navigator.of(context).pushNamedAndRemoveUntil(PageRoutes.signInRoot, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
