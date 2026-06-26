import '../entities/life_area.dart';

abstract class LifeAreaRepository {

  Future<List<LifeArea>> getAll();

  Future<void> create(LifeArea area);

  Future<void> update(LifeArea area);

  Future<void> delete(String id);
}
