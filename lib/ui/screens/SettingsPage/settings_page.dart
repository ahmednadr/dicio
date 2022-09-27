import 'package:flutter/material.dart';
import 'package:test/api/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/ui/screens/LoginPage/login_page.dart';
import 'package:test/ui/screens/ScanPage/scan_page.dart';
import 'package:test/ui/screens/SettingsPage/settings_view_model.dart';
// import for providers to access ref and consumer statefulwidget

class SettingsPage extends ConsumerStatefulWidget {
  //must be consumerstatefulwidget to access ref
  SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  var settings;
  late List<String> list = [];
  @override
  void initState() {
    super.initState();
    settings = ref.read(SettingsProvider);
    getServers();
  }

  Future<void> getServers() async {
    var map = await settings.serversList();
    List<String> tmp = [];
    map.forEach((key, value) {
      tmp.add(key);
    });
    setState(() {
      list = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 250, 0, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Card(
              elevation: 0.5,
              color: const Color(0xffE8E8E8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var widget = index == list.length - 1
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 25),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const ScanPage())));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    Icon(Icons.add),
                                    Text(
                                      "add server.",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: "Gilroy"),
                                    ),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                            Icons.settings_input_antenna),
                                        Text(
                                          list[index],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: "Gilroy"),
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                                // (index != 1 - 1)
                                //     ? const Divider(
                                //         color: Colors.black,
                                //       )
                                //     : const Padding(
                                //         padding: EdgeInsets.only(bottom: 25.0))
                              ],
                            );
                      return widget;
                    }),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(173, 244, 67, 54)),
              height: 50,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            settings.logout();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => const LogIn())));
          },
        )
      ],
    ));
  }
}
