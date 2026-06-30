import '../entities/life_area.dart';
import '../repositories/life_area_repository.dart';

class GetLifeAreas {
  final LifeAreaRepository repository;

  GetLifeAreas(this.repository);

  Future<List<LifeArea>> call() {
    return repository.getAll();
  }
}
