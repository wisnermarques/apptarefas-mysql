import '../../data/model/model.dart';
import '../../data/repository/tarefa_repository.dart';

class TarefaViewmodel {
  final TarefaRepository repository;

  TarefaViewmodel(this.repository);

  Future<void> addTarefa(Tarefa tarefa) async {
    await repository.insertTarefa(tarefa);
  }

  Future<List<Tarefa>> getTarefa() async {
    return await repository.getTarefas();
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    await repository.updateTarefa(tarefa);
  }

  Future<void> deleteTarefa(int? id) async {
    await repository.deleteTarefa(id!);
  }
}
