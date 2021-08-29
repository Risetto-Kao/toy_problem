import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouteConfig.homepage,
      getPages: RouteConfig.getPages,
    );
  }
}

class RouteConfig {
  static final String homepage = '/';
  static final String secondPage = '/second';

  static final List<GetPage> getPages = [
    GetPage(name: homepage, page: () => Homepage()),
    GetPage(name: secondPage, page: () => SecondPage())
  ];
}

class TestController extends GetxController {
  var count = 1.obs;
  void toSecondPage() => Get.toNamed(RouteConfig.secondPage);
  void increase() => count += 1;
  
}

class Homepage extends StatelessWidget {
  final TestController controller = Get.put(TestController(),tag: 'the second controller');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('page-one')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RouteConfig.secondPage),
        child: const Icon(Icons.arrow_forward_outlined),
      ),
      body: Center(
        child: Row(
          children: [
            TextButton(onPressed: controller.increase, child: Text('increase')),
            Obx(
              () => Text('page one click ${controller.count.value} times',
                  style: TextStyle(fontSize: 30.0)),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondController {
  var secondCount = 2.obs;
  void increase() => secondCount += 1;
  void decrease() => secondCount -= 1;
}

class SecondPage extends StatelessWidget {
  final TestController controller = Get.put(TestController(),tag: 'the second controller');

  // final TestController controller = Get.find();
  final SecondController secondController = Get.put(SecondController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('page-tw0')),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                controller.increase();
                secondController.decrease();
              },
              child: Text('++--')),
          Obx(() => Text('from 1 st page: count = ${controller.count.value}')),
          Obx(() => Text(
              'from 2 st page: count = ${secondController.secondCount.value}')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(RouteConfig.homepage)),
    );
  }
}
