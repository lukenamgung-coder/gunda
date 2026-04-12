import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Exposes incoming deep-links as a Riverpod stream.
///
/// The router (or any widget) can listen to this provider and react
/// to `gunda://` scheme URIs.
///
/// Current handlers:
///   gunda://kakaopay?violationId=<id>
///     → marks the violation as PaymentStatus.processing
final deepLinkProvider = StreamProvider<Uri?>((ref) {
  return AppLinks().uriLinkStream.handleError((_) {});
});
