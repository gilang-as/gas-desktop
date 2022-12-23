import '../example.dart';
import '../toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pkg/window/wm.dart';

class Launcher extends StatelessWidget {
  static const entry = WindowEntry(
    features: [
      ResizeWindowFeature(),
      ShadowWindowFeature(),
      FocusableWindowFeature(),
      SurfaceWindowFeature(),
      ToolbarWindowFeature(),
      PaddedContentWindowFeature(),
    ],
    layoutInfo: FreeformLayoutInfo(
      size: Size(400, 300),
      position: Offset.zero,
    ),
    properties: {
      WindowEntry.title: "Example window",
      WindowEntry.icon: null,
      ResizeWindowFeature.minSize: Size(320, 240),
      ResizeWindowFeature.maxSize: Size.infinite,
    },
  );

  const Launcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.955),
        borderRadius: const BorderRadius.all(Radius.circular(10)),

      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            Material(
              type: MaterialType.transparency,
              child: SizedBox(
                height: 360,
                width: double.infinity,
                child: ListView.builder(
                  itemBuilder: (context, index) => getAppLauncher(context),
                  itemCount: 8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.power_settings_new, size: 16),
                    label: const Text('Shutdown'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.restart_alt, size: 16),
                    label: const Text('Restart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppLauncher(BuildContext context) {
    return ListTile(
      leading: const FlutterLogo(size: 24),
      title: const Text("Example app"),
      subtitle: const Text(
        "Just a simple app to drag around and play with",
      ),
      onTap: () {
        WindowHierarchy.of(
          context,
          listen: false,
        ).addWindowEntry(entry.newInstance(
          content: const ExampleApp(),
          //eventHandler: LogWindowEventHandler(),
        ));

        Provider.of<ToolbarDirectorState>(
          context,
          listen: false,
        ).showLauncher = false;
      },
    );
  }
}

class ShadowWindowFeature extends WindowFeature {
  const ShadowWindowFeature();

  @override
  Widget build(BuildContext context, Widget content) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
          ),
        ],
      ),
      child: content,
    );
  }
}

class PaddedContentWindowFeature extends WindowFeature {
  const PaddedContentWindowFeature();

  @override
  Widget build(BuildContext context, Widget content) {
    final LayoutState layout = LayoutState.of(context);

    if (layout.fullscreen) return content;

    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 0, 1, 1),
      child: content,
    );
  }
}

class LogWindowEventHandler extends WindowEventHandler {
  @override
  void onEvent(WindowEvent event) {
    print(event);
    super.onEvent(event);
  }
}