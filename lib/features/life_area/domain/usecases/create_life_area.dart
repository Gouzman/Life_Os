import '../entities/life_area.dart';
import '../repositories/life_area_repository.dart';

class CreateLifeArea {

  final LifeAreaRepository repository;

  CreateLifeArea(this.repository);

  Future<void> call(LifeArea area) {

    return repository.create(area);
  }
}
