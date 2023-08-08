E? getLastOrNull<E>(List<E> list) {
  return list.isNotEmpty ? list[list.length - 1] : null;
}

extension ListExtensions<E> on List<E> {
  E? getLastOrNull() {
    return isNotEmpty ? this[length - 1] : null;
  }

  bool indexExists(int index) {
    return index >= 0 && index < length;
  }

  E? at(int index, {E? Function()? onElse}) {
    if (!indexExists(index)) {
      if (onElse != null) {
        return onElse();
      }

      return null;
    }

    return this[index];
  }
}
