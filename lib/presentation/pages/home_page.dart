import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/model/model.dart';
import '../../data/repository/tarefa_repository.dart';
import '../viewmodel/tarefa_viewmodel.dart';
import 'cadastro_page.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Tarefa> _tarefas = [];
  final TarefaViewmodel _viewModel = TarefaViewmodel(TarefaRepository());

  @override
  void initState() {
    super.initState();
    _loadTarefas();
  }

  Future<void> _loadTarefas() async {
    final tarefas = await _viewModel.getTarefa();
    if (mounted) {
      setState(() {
        _tarefas = tarefas
          ..removeWhere((t) => t.dataInicio.isEmpty || t.dataFim.isEmpty)
          ..sort((a, b) {
            DateTime dataA = DateTime.tryParse(a.dataInicio) ?? DateTime(2100);
            DateTime dataB = DateTime.tryParse(b.dataInicio) ?? DateTime(2100);
            return dataA.compareTo(dataB);
          });
      });
    }
  }

  void _deleteTarefaComUndo(Tarefa tarefa) async {
    await _viewModel.deleteTarefa(tarefa.id);
    if (mounted) {
      setState(() {
        _tarefas.removeWhere((t) => t.id == tarefa.id);
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarefa "${tarefa.nome}" excluída'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () async {
              await _viewModel.addTarefa(tarefa);
              _loadTarefas();
            },
          ),
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Em andamento':
        return Colors.blue.shade100;
      case 'Pendente':
        return Colors.red.shade100;
      case 'Concluída':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Em andamento':
        return Colors.blue;
      case 'Pendente':
        return Colors.red;
      case 'Concluída':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Tarefas'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _tarefas.isEmpty
            ? const Center(child: Text('Nenhuma tarefa disponível.'))
            : ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = _tarefas[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tarefa.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Descrição: ${tarefa.descricao}'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      'Início: ${DateFormat('dd/MM/yyyy').format(DateTime.tryParse(tarefa.dataInicio) ?? DateTime(2100))}')),
                              Expanded(
                                  child: Text(
                                      'Fim: ${DateFormat('dd/MM/yyyy').format(DateTime.tryParse(tarefa.dataFim) ?? DateTime(2100))}')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _getStatusColor(tarefa.status),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Status: ${tarefa.status}',
                              style: TextStyle(
                                color: _getStatusTextColor(tarefa.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditTarefaPage(tarefa: tarefa),
                                    ),
                                  ).then((wasUpdated) {
                                    if (wasUpdated == true) {
                                      _loadTarefas();
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTarefaComUndo(tarefa),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroTarefa()),
          ).then((_) => _loadTarefas());
        },
        backgroundColor: Colors.teal,
        tooltip: 'Adicionar Tarefa',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
