extension InputValidator<T> on Iterable<T> {
  T? find<K>(K Function(T) converter, K value, {String Function()? errorMessage}) {
    final options = where((element) => converter(element) == value);
    if (options.isNotEmpty) {
      return options.first;
    } else {
      if (errorMessage != null) {
        print(errorMessage());
      }
      return null;
    }
  }
}

extension StringInputValidator on String {
  int? tryParseToInt() => int.tryParse(this);
}
