/// A sealed class that holds either a successful result [Ok] or an error [Error].
sealed class Result<T> {
  const Result();

  factory Result.ok(T value) => Ok(value);
  factory Result.error(Exception error) => Error(error);
}

/// Successful result holding the returned [value].
final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

/// Error result holding the [error] that caused the failure.
final class Error<T> extends Result<T> {
  const Error(this.error);
  final Exception error;
}
