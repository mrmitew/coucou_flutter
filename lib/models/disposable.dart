typedef Action = void Function();

class Disposable {
  final Action _action;

  Disposable(this._action);

  void dispose() {
    _action();
  }
}
