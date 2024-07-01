import 'package:logger/logger.dart';
import 'dart:convert' as convert;

const String _tag = "loggerTag";
bool showLog = true;

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

LogV(String msg, {String tag = _tag}) {
  if (!showLog) {
    return;
  }

  _logger.v("$tag :: $msg");
}

LogD(String msg, {String tag = _tag}) {
  if (!showLog) {
    return;
  }

  _logger.d("$tag :: $msg");
}

LogI(String msg, {String tag = _tag}) {
  if (!showLog) {
    return;
  }

  _logger.i("$tag :: $msg");
}

LogW(String msg, {String tag = _tag}) {
  if (!showLog) {
    return;
  }

  _logger.w("$tag :: $msg");
}

LogE(String msg, {String tag = _tag}) {
  if (!showLog) {
    return;
  }

  _logger.e("$tag :: $msg");
}

LogWTF(String msg, {String tag = _tag}) {
  if (!showLog) return;
  _logger.wtf("$tag :: $msg");
}

class Log {
  static const int _maxLen = 128;

  static void printjJson(String msg, {String tag = _tag}) {
    if (!showLog) return;
    try {
      final dynamic data = convert.json.decode(msg);
      _printLog(tag, data);
    } catch (e) {
      _printLog(tag, msg);
    }
  }

  static void _printLog(String? tag, Object? object) {
    String da = object?.toString() ?? 'null';
    tag = tag ?? _tag;
    if (da.length <= _maxLen) {
      print('$tag $da');
      return;
    }
    print('$tag — — — — — — — — —— — — — — — st — — — — — — — — — — — — — —');
    while (da.isNotEmpty) {
      if (da.length > _maxLen) {
        print('$tag| ${da.substring(0, _maxLen)}');
        da = da.substring(_maxLen, da.length);
      } else {
        print('$tag| $da');
        da = '';
      }
    }
    print('$tag — — — — —  — — — — — — — — — ed — — — — — — — — — — — — — —');
  }
}
