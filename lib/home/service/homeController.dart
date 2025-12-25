import 'package:flutter/material.dart';
import 'package:wememmory/home/service/homeservice.dart';

class HomeController extends ChangeNotifier {
  HomeController({this.homeService = const HomeService()});
  HomeService homeService;

  dynamic user;

  getuser({required int id}) async {
    // user = null;
    user = await HomeService.getUserById(id: id);

    notifyListeners();
  }
}
