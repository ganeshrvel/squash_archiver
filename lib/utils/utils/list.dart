E? getLastOrNull<E>(List<E> list) {
  return list.isNotEmpty ? list[list.length - 1] : null;
}

extension ListExtensions<E> on List<E> {
  E? getLastOrNull() {
    return isNotEmpty ? this[length - 1] : null;
  }
}
