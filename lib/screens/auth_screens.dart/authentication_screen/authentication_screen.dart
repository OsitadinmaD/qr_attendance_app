import 'package:flutter/material.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/sign_up/signup_ui.dart';
import 'package:qr_attendance_app/screens/auth_screens.dart/widget/auth_tabBar_widget.dart';

import '../login_screen/login_ui.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key,});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: RangeMaintainingScrollPhysics(),
          child: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome Back to QR-Dentify',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                AuthTabbarWidget.tabBar(
                  tabController: _tabController,
                  tab1Label: 'Sign Up',
                  tab2Label: 'Sign In',
                ),
                AuthTabbarWidget().sessionTabBarView(
                  tabController: _tabController,
                  tab1Page: SignUpScreen(),
                  tab2Page: LoginScreen(),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}