import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:dio/dio.dart';
import 'package:test/api/config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

final authProvider = Provider<Auth>(((ref) {
  var config = ref.watch(configProvider);
  if (!config.isInit) throw Exception("config wasn't initiated");
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
  Future<String> authenticate(String username, String password) async {
    String token;
    // try {
    String authToken =
        await _getAuthToken(username, password, await _getFlowId());
    token = await _connectWS(await _getAccessToken(authToken));
    // } catch (e) {
    /// TODO: handle network exceptions and auth_invalid from ws and auth error from the rest api.
    // }
    assert(token != "");
    return token;
  }

  /// returns a [flow_id] thats refers to the login session.
  Future<String> _getFlowId() async {
    Response r = await Dio().post("$address/auth/login_flow", data: {
      "client_id": "http://acs",
      "handler": ["homeassistant", null],
      "redirect_uri": "http://acs/?auth_callback=1"
    });
    return r.data['flow_id'];
  }

  /// Takes [username], [password] and login session's [flowId] and sends an auth request.
  /// returns an [auth_token] if the auth was successful.
  Future<String> _getAuthToken(username, password, flowId) async {
    Response r = await Dio().post("$address/auth/login_flow/$flowId", data: {
      "username": "$username",
      "password": "$password",
      "client_id": "http://acs"
    });
    return r.data['result'];
  }

  /// Takes the [authToken] and returns a websocket [access_token].
  Future<String> _getAccessToken(authToken) async {
    final dio = Dio();
    Response r = await dio.post(
      "$address/auth/token",
      options: Options(contentType: Headers.formUrlEncodedContentType),
      data:
          'grant_type=authorization_code&code=$authToken&client_id=http://acs',
    );
    return r.data['access_token'];
  }

  /// Use [accessToken] to connect to a server via websocket and fetch a longlived token.
  Future<String> _connectWS(accessToken) async {
    var channel = IOWebSocketChannel.connect('ws://$ip:$port/api/websocket');
    String token = '';

    void __authWS() {
      channel.sink
          .add(jsonEncode({"type": "auth", "access_token": "$accessToken"}));
    }

    void __getLivelongToken() {
      channel.sink.add(jsonEncode({
        "id": "11",
        "type": "auth/long_lived_access_token",
        "client_name": "ACS ${DateTime.now()}",
        "client_icon": "null",
        "lifespan": 365
      }));
    }

    void __invaildAuthWS() {
      throw Exception("Authentication invalid");
    }

    await channel.stream.listen((event) {
      var json = jsonDecode(event);
      switch (json['type']) {
        case "auth_ok":
          __getLivelongToken();
          break;
        case "auth_required":
          __authWS();
          break;
        case "auth_invalid":
          __invaildAuthWS();
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
