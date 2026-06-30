import '../../domain/entities/life_area.dart';
import '../../domain/repositories/life_area_repository.dart';

class InMemoryLifeAreaRepository implements LifeAreaRepository {
  final List<LifeArea> _items;

  InMemoryLifeAreaRepository({List<LifeArea> initialItems = const []})
    : _items = List.of(initialItems);

  @override
  Future<void> create(LifeArea area) async {
    _items.add(area);
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((area) => area.id == id);
  }

  @override
  Future<List<LifeArea>> getAll() async {
    final activeItems = _items.where((area) => !area.isArchived).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return List.unmodifiable(activeItems);
  }

  @override
  Future<void> update(LifeArea area) async {
    final index = _items.indexWhere((item) => item.id == area.id);

    if (index == -1) {
      _items.add(area);
      return;
    }

    _items[index] = area;
  }
}
