import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../example.dart';
import '../toolbar/toolbar.dart';
import '../pkg/window/wm.dart';

class DockWidget extends StatefulWidget {
  const DockWidget({Key? key}) : super(key: key);

  @override
  State<DockWidget> createState() => _DockWidgetState();
}

class _DockWidgetState extends State<DockWidget> {
  late int? hoveredIndex;
  late double baseItemHeight;
  late double baseTranslationY;
  late double verticlItemsPadding;

  double getScaledSize(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseItemHeight,
      maxValue: 50,
      nonHoveredMaxValue: 50,
    );
  }

  double getTranslationY(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseTranslationY,
      maxValue: -10,
      nonHoveredMaxValue: -5,
    );
  }

  double getPropertyValue({
    required int index,
    required double baseValue,
    required double maxValue,
    required double nonHoveredMaxValue,
  }) {
    late final double propertyValue;

    // 1.
    if (hoveredIndex == null) {
      return baseValue;
    }

    // 2.
    final difference = (hoveredIndex! - index).abs();

    // 3.
    final itemsAffected = items.length;

    // 4.
    if (difference == 0) {
      propertyValue = maxValue;

      // 5.
    } else if (difference <= itemsAffected) {
      final ratio = (itemsAffected - difference) / itemsAffected;

      propertyValue = lerpDouble(baseValue, nonHoveredMaxValue, ratio)!;

      // 6.
    } else {
      propertyValue = baseValue;
    }

    return propertyValue;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hoveredIndex = null;
    baseItemHeight = 40;

    verticlItemsPadding = 5;
    baseTranslationY = 0.0;
  }

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 5,
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  height: baseItemHeight,
                  left: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade200.withOpacity(0.5),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                      // gradient: const LinearGradient(colors: [
                      //   Colors.blueAccent,
                      //   Colors.greenAccent,
                      // ]),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(verticlItemsPadding),
// 1.
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      items.length,
                          (index) {
                        // 2.
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: ((event) {
                            setState(() {
                              hoveredIndex = index;
                            });
                          }),
                          onExit: (event) {
                            setState(() {
                              hoveredIndex = null;
                            });
                          },
                          // 3.
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            transform: Matrix4.identity()
                              ..translate(
                                0.0,
                                getTranslationY(index),
                                0.0,
                              ),
                            height: getScaledSize(index),
                            width: getScaledSize(index),

                            alignment: AlignmentDirectional.bottomCenter,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 1,
                            ),
                            // 4.
                            child: FittedBox(
                                fit: BoxFit.contain,
                                // 5.
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  style: TextStyle(
                                    fontSize: getScaledSize(index),
                                  ),
                                  child:GestureDetector(
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
                                    child: Image.asset("icons/bin.png", height: 30, width: 30,),
                                  ),
                                )
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<String> items = [
  '🌟',
  '😍',
  '💙',
  '👋',
  '🗑️',
];


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