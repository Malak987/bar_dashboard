import 'package:dashboard_bar/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension ContextLocalization on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
