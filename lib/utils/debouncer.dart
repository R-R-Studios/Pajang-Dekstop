import 'dart:async';
import 'dart:ui';

class Debouncer {
  Duration? delay;
  Timer? _timer;
  late VoidCallback _callback;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void debounce(VoidCallback callback) {
    _callback = callback;

    cancel();
    if (delay != null) {
      _timer = Timer(delay!, flush);
    }
  }

  bool isActive() {
    if (_timer != null) {
      return _timer?.isActive ?? false;
    } else {
      return false;
    }
  }

  void cancel() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  void flush() {
    _callback();
    cancel();
  }
}
