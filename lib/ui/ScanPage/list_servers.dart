import 'package:flutter/material.dart';

class ListServers extends StatelessWidget {
  const ListServers({
    Key? key,
    required this.ips,
  }) : super(key: key);

  final Set ips;

  @override
  Widget build(BuildContext context) {
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
                        : const Padding(padding: EdgeInsets.only(bottom: 10.0))
                  ],
                );
              }),
        ),
      ),
    );
  }
}
