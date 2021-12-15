import 'package:shindenshin/shindenshin.dart';
import 'package:test/test.dart';

void main() {
  test('Correct getting repos from store', () {
    final Store store = Store();

    final dynamic aRepo = store.get<ARepo>();
    final bool isARepo = aRepo is ARepo;
    expect(isARepo, true);

    final dynamic cRepo = store<CRepo>();
    final bool isCRepo = cRepo is CRepo;
    expect(isCRepo, true);
  });
}

class Store extends BaseStore {
  Store() : super([
    ARepo.new,
    BRepo.new,
    CRepo.new,
  ], releaseBaseHost: '');
}

class ARepo extends BaseRepo {
  ARepo() : super();
}

class BRepo extends BaseRepo {
  BRepo() : super();
}

class CRepo extends BaseRepo {
  CRepo() : super();
}
