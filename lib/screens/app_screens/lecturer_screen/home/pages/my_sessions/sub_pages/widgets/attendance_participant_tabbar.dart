import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceParticipantTabbar{ 

  static PreferredSizeWidget tabBar({required TabController tabController, required String tab1Label, required String tab2Label}){
    return PreferredSize(
      preferredSize: Size.fromHeight(40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          width: Get.width * 0.9,
          color: Colors.blue.shade300,
          child: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6,left: 6),
                  child: Text(
                    tab1Label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5,left: 5),
                  child: Text(
                    tab2Label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.blue,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
  Widget sessionTabBarView({required TabController tabController, required Widget tab1Page, required Widget tab2Page}){
    return SizedBox(
      height: Get.height * 0.73,
      width: Get.width,
      child: TabBarView(
        controller: tabController,
        children: [
          SizedBox.expand(child: tab1Page),
          SizedBox.expand(child: tab2Page)
        ]
      ),
    );
  }
}