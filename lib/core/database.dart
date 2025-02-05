import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static Future<MySqlConnection> connect() async {
    final settings = ConnectionSettings(
      host:
          'sql10.freesqldatabase.com', // Ex: 'localhost' ou IP do servidor MySQL
      port: 3306, // Porta padrão do MySQL
      user: 'sql10761205',
      password: '7Vg5fnKNli',
      db: 'sql10761205',
    );

    final conn = await MySqlConnection.connect(settings);

    // Criar a tabela se não existir
    await conn.query('''
    CREATE TABLE IF NOT EXISTS tarefa (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        descricao TEXT,
        status VARCHAR(50) NOT NULL,
        dataInicio DATETIME,
        dataFim DATETIME
      )
    ''');

    return conn;
  }
}
