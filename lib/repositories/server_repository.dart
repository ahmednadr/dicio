import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum IpState { notAuthorized, authorized }

final loginViewModelProvider = StateNotifierProvider<ServerRepository, IpState>(
  (ref) {
    return ServerRepository();
  },
);

class ServerRepository extends StateNotifier<IpState> {
  ServerRepository() : super(IpState.notAuthorized);
}
