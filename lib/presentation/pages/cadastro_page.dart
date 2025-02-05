import 'package:app_gerenciamento_de_tarefas/data/model/model.dart';
import 'package:app_gerenciamento_de_tarefas/data/repository/tarefa_repository.dart';
import 'package:app_gerenciamento_de_tarefas/presentation/viewmodel/tarefa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CadastroTarefa extends StatefulWidget {
  const CadastroTarefa({super.key});

  @override
  State<CadastroTarefa> createState() => _CadastroTarefaState();
}

class _CadastroTarefaState extends State<CadastroTarefa> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();
  final TarefaViewmodel _viewModel = TarefaViewmodel(TarefaRepository());

  // Método para salvar a tarefa
  saveTarefa() async {
    try {
      if (_formKey.currentState!.validate()) {
        final tarefa = Tarefa(
          nome: nomeController.text,
          descricao: descricaoController.text,
          status: 'Pendente',
          dataInicio: DateFormat('dd/MM/yyyy')
              .parse(dataInicioController.text)
              .toIso8601String(),
          dataFim: DateFormat('dd/MM/yyyy')
              .parse(dataFimController.text)
              .toIso8601String(),
        );

        await _viewModel.addTarefa(tarefa);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa adicionada com sucesso!')),
          );
          Navigator.pop(context); // Fecha a página após salvar
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar a tarefa: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
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
        title: const Text('Cadastro de Tarefas'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Cadastrar uma Tarefa',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo Nome
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
                      // Campo Descrição
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
                      // Campo Data de Início
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
                      // Campo Data de Fim
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
                      // Botão de Salvar
                      ElevatedButton.icon(
                        onPressed: saveTarefa,
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
            )
          ],
        ),
      ),
    );
  }
}
