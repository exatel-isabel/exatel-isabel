import 'package:flutter/foundation.dart';
import 'package:isabel/models/funcionario.dart';

class FuncionarioProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Funcionario _funcionario = Funcionario(
    name: "Name",
    email: "E-mail",
  );

  Funcionario get funcionario => _funcionario;

  void addFuncionario(String name, String email) {
    _funcionario = Funcionario(
      name: name,
      email: email,
    );
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Funcionario>('funcionario', funcionario));
  }
}
