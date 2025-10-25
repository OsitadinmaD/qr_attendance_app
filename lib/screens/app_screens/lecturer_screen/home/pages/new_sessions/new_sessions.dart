import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/new_session_controller.dart';
import 'widgets/qr_cancel_save_buttons.dart';
import 'widgets/qr_code_inputs_data.dart';
import 'widgets/qr_code_visual_generate.dart';

class NewSessionsPage extends GetView<NewSessionController> {
  const NewSessionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          children: [
            QRCodeInputs(),
            SizedBox(height: 5,),
            QRCodeVisualGenerate(),
            QRCancelSaveButtons(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.13,)
          ],
        )
      )
    );
  }
}