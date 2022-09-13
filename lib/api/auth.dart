import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:dio/dio.dart';
import 'package:test/api/config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

final authProvider = Provider<Auth>(((ref) {
  var config = ref.watch(configProvider);
  return Auth(config.activeIp, config.port);
}));

class Auth {
  final String ip;
  final String port;
  late String address;

  /// Takes the values [ip] and [port]. retruns an instance for autherization.
  ///
  Auth(this.ip, this.port) {
    address = 'http://' + ip + ':' + port;
  }

  /// Takes the [username] and [password]. returns a new long lived token for this user.
  Future<String> Authenticate(String username, String password) async {
    var token;
    // try {
    print(username + password);
    String auth_token =
        await _get_auth_token(username, password, await _get_flow_id());
    token = await _connect_ws(await _get_access_token(auth_token));
    // } catch (e) {
    /// TODO: handle network exceptions and auth_invalid from ws and auth error from the rest api.
    // }
    assert(token != null);
    return token;
  }

  /// returns a [flow_id] thats refers to the login session.
  Future<String> _get_flow_id() async {
    Response r = await Dio().post("$address/auth/login_flow", data: {
      "client_id": "http://acs",
      "handler": ["homeassistant", null],
      "redirect_uri": "http://acs/?auth_callback=1"
    });
    return r.data['flow_id'];
  }

  /// Takes [username], [password] and login session's [flow_id] and sends an auth request.
  /// returns an [auth_token] if the auth was successful.
  Future<String> _get_auth_token(username, password, flow_id) async {
    Response r = await Dio().post("$address/auth/login_flow/$flow_id", data: {
      "username": "$username",
      "password": "$password",
      "client_id": "http://acs"
    });
    return r.data['result'];
  }

  /// Takes the [auth_token] and returns a websocket [access_token].
  Future<String> _get_access_token(auth_token) async {
    var dio = Dio();
    Response r = await Dio().post(
      "$address/auth/token",
      options: Options(contentType: Headers.formUrlEncodedContentType),
      data:
          'grant_type=authorization_code&code=$auth_token&client_id=http://acs',
    );
    return r.data['access_token'];
  }

  /// Use [access_token] to connect to a server via websocket and fetch a longlived token.
  Future<String> _connect_ws(access_token) async {
    var channel = IOWebSocketChannel.connect('ws://$ip:$port/api/websocket');
    var token = null;

    void __auth_ws() {
      channel.sink
          .add(jsonEncode({"type": "auth", "access_token": "$access_token"}));
    }

    void __get_livelong_token() {
      channel.sink.add(jsonEncode({
        "id": "11",
        "type": "auth/long_lived_access_token",
        "client_name": "ACS",
        "client_icon": "null",
        "lifespan": 365
      }));
    }

    void __invaild_auth_ws() {
      throw Exception("Authentication invalid");
    }

    await channel.stream.listen((event) {
      var json = jsonDecode(event);
      switch (json['type']) {
        case "auth_ok":
          __get_livelong_token();
          break;
        case "auth_required":
          __auth_ws();
          break;
        case "auth_invalid":
          __invaild_auth_ws();
          break;
        case "result":
          token = (json['result']);
          channel.sink.close(status.goingAway);
          break;
        default:
          throw Exception(event);
      }
    }).asFuture();

    return token;
  }
}
