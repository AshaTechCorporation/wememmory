import 'package:flutter/material.dart';
import 'package:wememmory/home/service/homeservice.dart';
import 'package:wememmory/models/userModel.dart';

class HomeController extends ChangeNotifier {
  HomeController({this.homeService = const HomeService()});
  HomeService homeService;

  UserModel? user;

  Future<void> getuser({required int id}) async {
    user = await HomeService.getUserById(id: id);

    notifyListeners();
  }
}
