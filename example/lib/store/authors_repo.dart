import 'package:example/models/author.dart';
import 'package:shindenshin/shindenshin.dart';

class AuthorsRepo extends BaseRepo {
  Pagination<Author> pagination = Pagination.empty();
  late final WebSocketService _webSocket;

  List<Author> get authors => pagination.results;
  bool get isWsConnected => _webSocket.isActive;

  AuthorsRepo(BaseStore store) : super(store) {
    _initWebSocket();
  }

  Future<void> fetch() async {
    final Map<String, dynamic> params = {'page': pagination.page};
    pagination = await AuthorApi().listPaginated(params: params);
  }

  Future<void> next([int? page]) {
    pagination = pagination.next(page);
    return fetch();
  }

  void _initWebSocket() {
    _webSocket = WebSocketService(
      Uri(
        host: 'ws.example.com',
        scheme: 'wss',
      ),
      onReceive: _onWsEvent,
    );
  }

  Future<void> _onWsEvent(WebSocketEventMessage event) async {
    if (event.type == 'author_list_updated') {
      fetch();
      notify(AuthorListUpdated());
    }
  }
}

class AuthorListUpdated extends StoreEvent {}
