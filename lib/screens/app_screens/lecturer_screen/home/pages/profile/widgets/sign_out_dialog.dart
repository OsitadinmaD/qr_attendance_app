import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../auth_screens.dart/login_screen/controller/login_controller.dart';

Future<dynamic> signOutDialog(BuildContext context, LoginController logOutController) {
    return showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Sign Out',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          actions: [
                            OutlinedButton(
                              style: ButtonStyle(
                                side: WidgetStatePropertyAll(BorderSide(color: Colors.white))
                              ),
                                onPressed: () => Get.back(),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )),
                            FilledButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(const Color.fromRGBO(244, 67, 54, 1))),
                              onPressed: () => logOutController.logOut(),
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          content: Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      });
  }