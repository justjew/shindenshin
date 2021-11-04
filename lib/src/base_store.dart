import 'package:shindenshin/src/api_client.dart';
import 'package:shindenshin/src/subscriptable.dart';

abstract class BaseStore extends Subscriptable {
  final String releaseBaseHost;

  BaseStore({required this.releaseBaseHost}) {
    initApiClient();
  }

  void initApiClient() {
    ApiClient().init(releaseBaseHost: releaseBaseHost);
  }
}
