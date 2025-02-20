import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en')) {
    setLanguage();
  }

  void setLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('language') &&
        preferences.getString('language')!.isNotEmpty) {
      emit(Locale(preferences.getString('language')!));
    } else {
      emit(const Locale('en'));
    }
  }

  void selectEngLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'en');
    emit(const Locale('en'));
  }

  void selectArabicLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'ar');
    emit(const Locale('ar'));
  }

  void selectPortugueseLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'pt');
    emit(const Locale('pt'));
  }

  void selectFrenchLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'fr');
    emit(const Locale('fr'));
  }

  void selectIndonesianLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'id');
    emit(const Locale('id'));
  }

  void selectSpanishLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'es');
    emit(const Locale('es'));
  }

  void selectBulgarianLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', 'bg');
    emit(const Locale('bg'));
  }
}
