import 'widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pkg/window/wm.dart';

class DockDirector extends StatefulWidget {
  const DockDirector({Key? key}) : super(key: key);

  @override
  State<DockDirector> createState() => DockDirectorState();
}

class DockDirectorState extends State<DockDirector> {
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
      child: const DockWidget(),
    );
  }
}
