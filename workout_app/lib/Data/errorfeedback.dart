import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:workout_app/globals.dart';

Future<void> saveError(errormessage,widgetname) async {
  Future<void> _postError(errormessage, widgetname) async {
    final errortosave = {
      'errormessage': errormessage,
      'widgetname': widgetname,
    };
    final response = await supabase.from('errors')
        .insert(errortosave)
        .execute();
    if (response.error != null) {
      SnackBar snackBar = SnackBar(content: Text(response.error!.message),backgroundColor: Colors.red,);
      snackbarerrorkey.currentState?.showSnackBar(snackBar);
    }
  }
  _postError(errormessage, widgetname);
}