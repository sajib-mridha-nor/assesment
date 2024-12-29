import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart/home_page_controller.dart';
 // Import your controller

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.put(HomePageController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.userList.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return ListView.builder(
          itemCount: controller.userList.length,
          itemBuilder: (context, index) {
            final user = controller.userList[index];
            return ListTile(
              title: Text(user.name ?? 'No Name'),
              subtitle: Text(user.email ?? 'No Email'),
            );
          },
        );
      }),
    );
  }
}
