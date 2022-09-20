import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum IpState { init, notAuthorized, authorized }

class ServerRepository extends ChangeNotifier {}
