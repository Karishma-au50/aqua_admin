import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class MyToasts {
  static _getSimpleSnackbar({required String text, bool isError = false}) {
    toastification.show(
        title: Text(text),
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green,
        icon: Icon(isError ? Icons.info : Icons.done, color: Colors.white));
  }

  static toastSuccess(String text) {
    _getSimpleSnackbar(text: text);
  }

  static toastError(String text) {
    _getSimpleSnackbar(text: text, isError: true);
  }

  static getButtonSnackbar(
      {required String text,
      bool isError = false,
      required Function onPressed}) {
    Get.showSnackbar(
      GetSnackBar(
        message: text,
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(20),
        borderRadius: 10,
        mainButton: TextButton(
          onPressed: () {
            onPressed();
          },
          child: ElevatedButton(
            onPressed: () {
              onPressed();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text("Login"),
          ),
        ),
      ),
    );
  }
}
