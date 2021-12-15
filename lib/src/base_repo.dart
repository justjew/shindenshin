import 'package:shindenshin/src/subscriptable.dart';

abstract class BaseRepo extends Subscriptable {
  void dispose() {
    eventPool.close();
  }
}
