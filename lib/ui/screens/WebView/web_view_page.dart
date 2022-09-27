import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:test/api/config.dart';
import 'package:test/ui/screens/SettingsPage/settings_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HAWebView extends ConsumerStatefulWidget {
  const HAWebView({Key? key}) : super(key: key);

  @override
  ConsumerState<HAWebView> createState() => _HAWebViewState();
}

class _HAWebViewState extends ConsumerState<HAWebView> {
  @override
  Widget build(BuildContext context) {
    var config = ref.watch(configProvider);

    Widget launchAuthenticatedWebView(BuildContext context, String url) {
      if (url.contains("?")) {
        url += "&external_auth=1";
      } else {
        url += "?external_auth=1";
      }
      String js = '''
window.webkit.messageHandlers.getExternalAuth = {};
window.webkit.messageHandlers.getExternalAuth.postMessage = function(options) {
    window.alert("Starting external auth");
    var options = JSON.parse(options);
    if (options && options.callback) {
        var responseData = {
            access_token: "[token]",
            expires_in: 1800
        };
        window.alert("Waiting for callback to be added");
        setTimeout(function(){
            window.alert("Calling a callback");
            window[options.callback](true, responseData);
        }, 900);
    }
};
'''
          .replaceFirst("[token]", config.activeServer.longLivedToken!);
      var _controller;
      WebView flutterWebView = WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          onPageStarted: (url) {
            _controller.runJavascript(js);
          });

      // Navigator.of(context).pushNamed("/webview",
      //     arguments: {"url": "$url", "title": "${title ?? ''}"});

      return flutterWebView;
    }

    return Scaffold(
      body: Center(
          child: launchAuthenticatedWebView(
              context, 'http://${config.activeIp}:${config.port}')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => SettingsPage()))),
      ),
    );
  }
}
