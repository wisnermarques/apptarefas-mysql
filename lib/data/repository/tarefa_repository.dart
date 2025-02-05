import '../../core/database.dart';
import '../model/model.dart';

class TarefaRepository {
  Future<void> insertTarefa(Tarefa tarefa) async {
    final conn = await DatabaseHelper.connect();
    await conn.query(
      'INSERT INTO tarefa (nome, descricao, status, dataInicio, dataFim) VALUES (?, ?, ?, ?, ?)',
      [
        tarefa.nome,
        tarefa.descricao,
        tarefa.status,
        DateTime.parse(tarefa.dataInicio).toUtc(),
        DateTime.parse(tarefa.dataFim).toUtc(),
      ],
    );
    await conn.close();
  }

  Future<List<Tarefa>> getTarefas() async {
    final conn = await DatabaseHelper.connect();
    final results = await conn.query('SELECT * FROM tarefa');
    final tarefas = results.map((row) {
      return Tarefa(
        id: row['id'] as int,
        nome: row['nome'] as String,
        descricao: row['descricao']
            .toString(), // Garantindo que descricao seja tratada como String
        status: row['status'] as String,
        dataInicio: (row['dataInicio'] as DateTime).toIso8601String(),
        dataFim: (row['dataFim'] as DateTime).toIso8601String(),
      );
    }).toList();
    await conn.close();
    return tarefas;
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    final conn = await DatabaseHelper.connect();
    await conn.query(
      '''UPDATE tarefa SET nome = ?, descricao = ?, status = ?, dataInicio = ?, 
          dataFim = ? WHERE id = ?''',
      [
        tarefa.nome,
        tarefa.descricao,
        tarefa.status,
        DateTime.parse(tarefa.dataInicio).toUtc(),
        DateTime.parse(tarefa.dataFim).toUtc(),
        tarefa.id,
      ],
    );
    await conn.close();
  }

  Future<void> deleteTarefa(int id) async {
    final conn = await DatabaseHelper.connect();
    await conn.query('DELETE FROM tarefa WHERE id = ?', [id]);
    await conn.close();
  }
}
