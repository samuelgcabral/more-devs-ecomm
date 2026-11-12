import 'package:flutter/widgets.dart';
import 'package:more_devs_do_zero/shared/analytics/app_analytics.dart';
import 'package:provider/provider.dart';

// Envia o screen_view uma única vez, quando a página entra na árvore.
// Fica no initState (e não no build) para não disparar a cada rebuild.
mixin AnalyticsMixin<T extends StatefulWidget> on State<T> {
  // Route da página, ex.: LoginPage.route.
  String get screenName;

  AppAnalytics get analytics => context.read<AppAnalytics>();

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenName);
  }
}
