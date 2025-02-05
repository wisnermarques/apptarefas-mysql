import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/model/model.dart';
import '../../data/repository/tarefa_repository.dart';
import '../viewmodel/tarefa_viewmodel.dart';

class EditTarefaPage extends StatefulWidget {
  final Tarefa tarefa; // Tarefa a ser editada

  const EditTarefaPage({super.key, required this.tarefa});

  @override
  State<EditTarefaPage> createState() => _EditTarefaPageState();
}

class _EditTarefaPageState extends State<EditTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController dataInicioController;
  late TextEditingController dataFimController;

  final TarefaViewmodel _viewModel = TarefaViewmodel(TarefaRepository());
  String? _status; // Status selecionado

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com os valores da tarefa
    nomeController = TextEditingController(text: widget.tarefa.nome);
    descricaoController = TextEditingController(text: widget.tarefa.descricao);
    dataInicioController = TextEditingController(
        text: DateFormat('dd/MM/yyyy')
            .format(DateTime.tryParse(widget.tarefa.dataInicio)!));
    dataFimController = TextEditingController(
        text: DateFormat('dd/MM/yyyy')
            .format(DateTime.tryParse(widget.tarefa.dataFim)!));
    _status = widget.tarefa.status; // Inicializa o status
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    dataInicioController.dispose();
    dataFimController.dispose();
    super.dispose();
  }

  Future<void> saveEdits() async {
    if (_formKey.currentState!.validate()) {
      final updatedTarefa = Tarefa(
        id: widget.tarefa.id,
        nome: nomeController.text,
        descricao: descricaoController.text,
        status: _status ?? "Pendente", // Usa o status selecionado
         dataInicio: DateFormat('dd/MM/yyyy')
              .parse(dataInicioController.text)
              .toIso8601String(),
          dataFim: DateFormat('dd/MM/yyyy')
              .parse(dataFimController.text)
              .toIso8601String(),
      );

      try {
        await _viewModel.updateTarefa(updatedTarefa);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa atualizada com sucesso!')),
          );
          Navigator.pop(context, true); // Retorna à tela anterior
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao atualizar a tarefa: ${e.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Método para exibir o calendário e formatar a data
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal, // Cor de destaque do calendário
              onPrimary: Colors.white, // Cor do texto nos botões selecionados
              onSurface: Colors.black, // Cor do texto
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            DateFormat('dd/MM/yyyy').format(pickedDate); // Formatação BR
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Editar Tarefa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.teal.shade700),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor entre com um nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descricaoController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: TextStyle(color: Colors.teal.shade700),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade700),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor entre com a descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      labelStyle: TextStyle(color: Colors.teal.shade700),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade700),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Pendente',
                        child: Text('Pendente'),
                      ),
                      DropdownMenuItem(
                        value: 'Em andamento',
                        child: Text('Em andamento'),
                      ),
                      DropdownMenuItem(
                        value: 'Concluído',
                        child: Text('Concluído'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecione um status';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                        controller: dataInicioController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Data de Início',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, dataInicioController),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com a data de início';
                          }
                          return null;
                        },
                      ),
                  const SizedBox(height: 16),
                  TextFormField(
                        controller: dataFimController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Data de Fim',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, dataFimController),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com a data de fim';
                          }
                          return null;
                        },
                      ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: saveEdits,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 30.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    icon: const Icon(Icons.save, size: 24),
                    label: const Text(
                      'Salvar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
