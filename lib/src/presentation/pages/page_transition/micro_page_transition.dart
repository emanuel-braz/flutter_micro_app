import 'package:flutter/material.dart';

import '../../../../flutter_micro_app.dart';
import 'transition_effects.dart';

class MicroPageTransition<T> extends PageRouteBuilder<T> {
  /// [childCurrent]
  final Widget? childCurrent;

  /// [MicroPageTransitionType]
  final MicroPageTransitionType type;

  /// [Curve]
  final Curve curve;

  /// [Alignment]
  final Alignment alignment;

  /// [Duration]
  final Duration duration;

  /// [Duration]
  final Duration reverseDuration;

  /// [BuildContext]
  final BuildContext? context;

  /// [bool]
  final bool inheritTheme;

  MicroPageTransition({
    Key? key,
    required this.type,
    required WidgetPageBuilder pageBuilder,
    this.childCurrent,
    this.context,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    bool fullscreenDialog = false,
    bool opaque = false,
    RouteSettings? settings,
  })  : assert(inheritTheme ? context != null : true,
            "'context' cannot be null when 'inheritTheme' is true, set context: context"),
        super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            Widget child = pageBuilder(
                context,
                RouteSettings(
                  name: settings?.name,
                  arguments: settings?.arguments,
                ));
            return inheritTheme
                ? InheritedTheme.captureAll(
                    context,
                    child,
                  )
                : child;
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          settings: settings,
          maintainState: true,
          opaque: opaque,
          fullscreenDialog: fullscreenDialog,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            switch (type) {
              case MicroPageTransitionType.fade:
                return FadeTransition(opacity: animation, child: child);

              case MicroPageTransitionType.rightToLeft:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );

              case MicroPageTransitionType.leftToRight:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );

              case MicroPageTransitionType.topToBottom:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );

              case MicroPageTransitionType.bottomToTop:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );

              case MicroPageTransitionType.scale:
                return ScaleTransition(
                  alignment: alignment,
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Interval(
                      0.00,
                      0.50,
                      curve: curve,
                    ),
                  ),
                  child: child,
                );

              case MicroPageTransitionType.rotate:
                return RotationTransition(
                  alignment: alignment,
                  turns: animation,
                  child: ScaleTransition(
                    alignment: alignment,
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                );

              case MicroPageTransitionType.size:
                return Align(
                  alignment: alignment,
                  child: SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: animation,
                      curve: curve,
                    ),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.rightToLeftWithFade:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                );

              case MicroPageTransitionType.leftToRightWithFade:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: curve,
                    ),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                );

              case MicroPageTransitionType.rightToLeftJoined:
                assert(childCurrent != null, """
                When using type "rightToLeftJoined" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
                return Stack(
                  children: <Widget>[
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.0),
                        end: const Offset(-1.0, 0.0),
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        ),
                      ),
                      child: childCurrent,
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        ),
                      ),
                      child: child,
                    )
                  ],
                );

              case MicroPageTransitionType.leftToRightJoined:
                assert(childCurrent != null, """
                When using type "leftToRightJoined" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
                return Stack(
                  children: <Widget>[
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: const Offset(0.0, 0.0),
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        ),
                      ),
                      child: child,
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.0),
                        end: const Offset(1.0, 0.0),
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        ),
                      ),
                      child: childCurrent,
                    )
                  ],
                );

              case MicroPageTransitionType.slideZoomLeft:
                return SlideTransition(
                  position: t1.animate(animation),
                  child: ScaleTransition(
                    scale: t13.animate(secondaryAnimation),
                    child: child,
                  ),
                );
              case MicroPageTransitionType.slideZoomRight:
                return SlideTransition(
                  position: t2.animate(animation),
                  child: ScaleTransition(
                    scale: t13.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.slideZoomUp:
                return SlideTransition(
                  position: t3.animate(animation),
                  child: ScaleTransition(
                    scale: t13.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.slideZoomDown:
                return SlideTransition(
                  position: t4.animate(animation),
                  child: ScaleTransition(
                    scale: t13.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.slideLeft:
                return SlideTransition(
                  position: t1.animate(animation),
                  child: SlideTransition(
                    position: t5.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.slideInRight:
                return SlideTransition(
                  position: t2.animate(animation),
                  child: SlideTransition(
                    position: t5.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.slideInUp:
                return SlideTransition(
                  position: t3.animate(animation),
                  child: SlideTransition(
                    position: t5.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.slideInDown:
                return SlideTransition(
                  position: t4.animate(animation),
                  child: SlideTransition(
                    position: t5.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.rippleRightUp:
                return ClipPath(
                  clipper:
                      RippleClipper(origin: 'Right', progress: animation.value),
                  child: child,
                );

              case MicroPageTransitionType.rippleLeftUp:
                return ClipPath(
                  clipper:
                      RippleClipper(origin: 'Left', progress: animation.value),
                  child: child,
                );

              case MicroPageTransitionType.rippleLeftDown:
                return ClipPath(
                  clipper: RippleClipper(
                      origin: 'LeftDown', progress: animation.value),
                  child: child,
                );

              case MicroPageTransitionType.rippleRightDown:
                return ClipPath(
                  clipper: RippleClipper(
                      origin: 'RightDown', progress: animation.value),
                  child: child,
                );

              case MicroPageTransitionType.rippleMiddle:
                return ClipPath(
                  clipper: RippleClipper(
                      origin: 'Middle', progress: animation.value),
                  child: child,
                );

              case MicroPageTransitionType.slideParallaxLeft:
                return SlideTransition(
                  position: t1.animate(animation),
                  child: SlideTransition(
                    position: t9.animate(secondaryAnimation),
                    child: child,
                  ),
                );
              case MicroPageTransitionType.slideParallaxRight:
                return SlideTransition(
                  position: t2.animate(animation),
                  child: SlideTransition(
                    position: t10.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.slideParallaxUp:
                return SlideTransition(
                  position: t3.animate(animation),
                  child: SlideTransition(
                    position: t11.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case MicroPageTransitionType.slideParallaxDown:
                return SlideTransition(
                  position: t4.animate(animation),
                  child: SlideTransition(
                    position: t12.animate(secondaryAnimation),
                    child: child,
                  ),
                );

              default: //none
                return child;
            }
          },
        );
}
