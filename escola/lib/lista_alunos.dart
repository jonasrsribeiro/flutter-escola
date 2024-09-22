import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Aluno {
  final String matricula;
  final String nome;
  final int nota;

  Aluno({required this.matricula, required this.nome, required this.nota});

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      matricula: json['matricula'],
      nome: json['nome'],
      nota: json['nota'],
    );
  }
}

class ListaAlunosPage extends StatefulWidget {
  const ListaAlunosPage({super.key});

  @override
  ListaAlunosPageState createState() => ListaAlunosPageState();
}

class ListaAlunosPageState extends State<ListaAlunosPage> {
  List<Aluno> alunos = [];
  List<Aluno> alunosFiltrados = [];
  String filterType = 'all';

  @override
  void initState() {
    super.initState();
    _fetchAlunos();
  }

  Future<void> _fetchAlunos() async {
    final response = await http.get(Uri.parse('http://demo4909971.mockable.io/notasAlunos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        alunos = data.map((json) => Aluno.fromJson(json)).toList();
        alunosFiltrados = List.from(alunos);
      });
    } else {
      throw Exception('Falha ao carregar alunos');
    }
  }

  void _filterAlunos(String type) {
    setState(() {
      filterType = type;
      if (type == 'menos60') {
        alunosFiltrados = alunos.where((aluno) => aluno.nota < 60).toList();
      } else if (type == 'mais60') {
        alunosFiltrados = alunos.where((aluno) => aluno.nota >= 60 && aluno.nota < 100).toList();
      } else if (type == 'nota100') {
        alunosFiltrados = alunos.where((aluno) => aluno.nota == 100).toList();
      } else {
        alunosFiltrados = List.from(alunos);
      }
    });
  }

  Color _getBackgroundColor(int nota) {
    if (nota == 100) return Colors.green;
    if (nota < 60) return Colors.yellow;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alunos'),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: alunosFiltrados.length,
              itemBuilder: (context, index) {
                final aluno = alunosFiltrados[index];
                return Container(
                  color: _getBackgroundColor(aluno.nota),
                  child: ListTile(
                    title: Text(aluno.nome),
                    subtitle: Text('Matrícula: ${aluno.matricula}, Nota: ${aluno.nota}'),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _filterAlunos('menos60'),
                child: const Text('< 60'),
              ),
              ElevatedButton(
                onPressed: () => _filterAlunos('mais60'),
                child: const Text('>= 60'),
              ),
              ElevatedButton(
                onPressed: () => _filterAlunos('nota100'),
                child: const Text('100'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
