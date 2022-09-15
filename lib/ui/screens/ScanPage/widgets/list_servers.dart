import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/api/config.dart';
import 'package:test/api/scan.dart';

class ListServers extends ConsumerStatefulWidget {
  const ListServers({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ListServers> createState() => _ListServersState();
}

class _ListServersState extends ConsumerState<ListServers> {
  @override
  Widget build(BuildContext context) {
    final config = ref.read(configProvider);
    final ips = ref.watch(scanProvider).ips;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Card(
        elevation: 0,
        color: const Color(0xffE8E8E8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView.builder(
              itemCount: ips.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () async {
                          await config.changeIp(ips.elementAt(index));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Center(
                                        child: Text(
                                          "${config.activeIp} is ${config.configState}",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ))));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(Icons.settings_input_antenna),
                            Text(
                              ips.elementAt(index),
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
                    (index != ips.length - 1)
                        ? const Divider(
                            color: Colors.black,
                          )
                        : const Padding(padding: EdgeInsets.only(bottom: 25.0))
                  ],
                );
              }),
        ),
      ),
    );
  }
}
