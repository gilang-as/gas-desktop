import 'package:desktop/dock.dart';

import '../components/launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pkg/window/wm.dart';

import '../components/taskbar.dart';

class ToolbarDirector extends StatefulWidget {
  const ToolbarDirector({Key? key}) : super(key: key);

  @override
  State<ToolbarDirector> createState() => ToolbarDirectorState();
}

class ToolbarDirectorState extends State<ToolbarDirector> {
  bool _showLauncher = false;

  bool get showLauncher => _showLauncher;
  set showLauncher(bool value) {
    _showLauncher = value;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WindowHierarchy.of(context, listen: false).wmInsets =
      const EdgeInsets.only(bottom: 48);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: this,
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Listener(
                onPointerDown: (event) {
                  showLauncher = false;
                },
                behavior: HitTestBehavior.translucent,
              ),
            ),
            Taskbar(
              controller: WindowHierarchy.of(context),
            ),
            Positioned(
              top: 24,
              left: 5,
              width: 320,
              child: Offstage(
                offstage: !_showLauncher,
                child: const Launcher(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}