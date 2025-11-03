import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum ToastLength { short, long }

enum ToastGravity { bottom, center, top }

class ToastService {
  const ToastService._();

  static const MethodChannel _channel = MethodChannel('dev.koit.abs_wear/toast');

  static Future<void> showToast({
    required String message,
    ToastLength length = ToastLength.short,
    ToastGravity gravity = ToastGravity.bottom,
  }) async {
    try {
      await _channel.invokeMethod<void>(
        'showToast',
        <String, dynamic>{
          'message': message,
          'length': length.name,
          'gravity': gravity.name,
        },
      );
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print('Failed to display toast: $error');
      }
    }
  }
}
