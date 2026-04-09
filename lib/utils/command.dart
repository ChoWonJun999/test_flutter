import 'package:app/utils/result.dart';
import 'package:flutter/foundation.dart';

/// Abstract base class for all Command types.
///
/// Wraps an async action and exposes [running], [error], and [completed]
/// states so the UI can react accordingly.
abstract class Command<T> extends ChangeNotifier {
  bool _running = false;
  Result<T>? _result;

  bool get running => _running;
  bool get canExecute => !_running;
  bool get hasResult => _result != null;

  Result<T>? get result => _result;

  T? get value {
    final currentResult = _result;
    if (currentResult is Ok<T>) {
      return currentResult.value;
    }
    return null;
  }

  Exception? get exception {
    final currentResult = _result;
    if (currentResult is Error<T>) {
      return currentResult.error;
    }
    return null;
  }

  /// true if the action completed with an error.
  bool get error => _result is Error;

  /// true if the action completed successfully.
  bool get completed => _result is Ok;

  Future<Result<T>?> _execute(Future<Result<T>> Function() action) async {
    if (_running) return null;

    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
      return _result;
    } finally {
      _running = false;
      notifyListeners();
    }
  }

  void clearResult() {
    _result = null;
    notifyListeners();
  }
}

/// A [Command] that takes no arguments.
class Command0<T> extends Command<T> {
  Command0(this._action);

  final Future<Result<T>> Function() _action;

  Future<void> execute() async {
    await _execute(_action);
  }

  Future<Result<T>?> executeAndGet() => _execute(_action);
}

/// A [Command] that takes one argument of type [A].
class Command1<T, A> extends Command<T> {
  Command1(this._action);

  final Future<Result<T>> Function(A) _action;

  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }

  Future<Result<T>?> executeAndGet(A argument) => _execute(() => _action(argument));
}
