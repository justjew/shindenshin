import 'dart:async';

abstract class Subscriptable {
  final StreamController<StoreEvent> eventPool = StreamController<StoreEvent>.broadcast();

  StreamSubscription<StoreEvent> subscribe(
    Function(StoreEvent event) fn, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return eventPool.stream.listen(
      fn,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void notify(StoreEvent event) {
    eventPool.add(event);
  }
}

abstract class StoreEvent {
  final dynamic initiator;

  StoreEvent({this.initiator});
}
