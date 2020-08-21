import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


const kEmail_sh='email' ;
const kPassword_sh='password' ;


class SharedPref{
  SharedPreferences _preferences ;



  Future<void> addStringToSF({@required String key, @required String value}) async {
    _preferences = await SharedPreferences.getInstance() ;
    _preferences.setString(key, value);
  }

  Future<void> addIntToSF({@required String key,@required int value}) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setInt(key, value);
  }


  Future<String> getStringValuesSF({@required String key}) async {
    _preferences=await SharedPreferences.getInstance() ;
    return (_preferences.getString(key));
  }

   Future<int> getIntValuesSF({@required String key}) async{
    _preferences=await SharedPreferences.getInstance() ;
    return(_preferences.getInt(key));
  }

}