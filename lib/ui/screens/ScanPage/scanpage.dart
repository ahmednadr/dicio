import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/api/config.dart';
import 'package:test/api/scan.dart';
import 'package:test/ui/screens/ScanPage/scan_states.dart';
import 'package:test/ui/screens/ScanPage/scan_view_model.dart';
import 'package:test/ui/widgets/bouncing_ball.dart';
import 'scan_animation.dart';
import 'widgets/list_servers.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..stop();
  @override
  void dispose() {
    _controller
      ..clearListeners()
      ..dispose();
    super.dispose();
  }

  bool first = true;
  Widget _child = BouncingBall();
  late ScanViewModel vm;
  double connectOpacity = 1;

  @override
  Widget build(BuildContext context) {
    final vmState = ref.watch(ScanViewModel.scanViewModelProvider);
    vm = ref.read(ScanViewModel.scanViewModelProvider.notifier);

    handleStates(vmState);

    return Scaffold(
      body: Center(
          child: SizedBox.expand(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeOutBack,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _child),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              child: AnimatedOpacity(
                opacity: connectOpacity,
                duration: const Duration(milliseconds: 400),
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: const Color(0xbbd82258),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          height: 50,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                'Connect without Server',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        onTap: () => DoNothingAction(),
                      )),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void handleStates(ScanStates state) {
    switch (state) {
      case ScanStates.init:
        _child = const BouncingBall();
        break;
      case ScanStates.idle:
        _child = ScanAnimation(
          controller: _controller,
        );
        break;
      case ScanStates.timeout:
        _controller.reset();
        break;
      case ScanStates.scanning:
        connectOpacity = 0;
        break;
      case ScanStates.finished:
        _child = ListServers();
        break;
      case ScanStates.error:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _controller.reset();
          vm.handleError(context);
        });
        break;
    }
  }
}
