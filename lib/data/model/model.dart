class Tarefa {
  final int? id; // Permite ser null
  final String nome;
  final String descricao;
  final String status;
  final String dataInicio;
  final String dataFim;

  Tarefa({
    this.id,
    required this.nome,
    required this.descricao,
    required this.status,
    required this.dataInicio,
    required this.dataFim,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'status': status,
      'dataInicio': dataInicio,
      'dataFim': dataFim
    };
  }
}
