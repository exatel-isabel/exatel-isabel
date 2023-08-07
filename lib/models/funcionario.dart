class Funcionario {
  String name;
  String email;
  bool permissao;

  Funcionario({
    required this.name,
    required this.email,
    this.permissao = false,
  });
}
