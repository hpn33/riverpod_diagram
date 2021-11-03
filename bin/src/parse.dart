import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

List<VariableDeclaration> processFile(AnalysisSession session, String path) {
  final providersList = <VariableDeclaration>[];

  var result = session.getParsedUnit(path);

  if (result is ParsedUnitResult) {
    CompilationUnit unit = result.unit;
    unit.visitChildren(IfCounter(providersList));

    // providersList.forEach((element) {
    //   print(element.name);
    // });

    // printMembers(unit);

  }

  return providersList;
}

class IfCounter extends SimpleAstVisitor<void> {
  final List providersList;

  IfCounter(this.providersList);

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    // print('------ ${node.variables.type}');

    for (var element in node.variables.variables) {
      if (element.name.toString().contains('Provider')) {
        providersList.add(element);
      }

      //   print(element.name);
      //   print(element.initializer);
      //   // print(element.childEntities);
      //   // print(element);
      //   // print(element.runtimeType);
      //   // print(element.name.name.contains('Provider'));

      //   if (element.declaredElement != null) {
      //     print(element.declaredElement);
      //     print(element.declaredElement!.name);
      //     print(element.declaredElement!.type);
      //   }
    }
  }
}

void printMembers(CompilationUnit unit) {
  for (CompilationUnitMember unitMember in unit.declarations) {
    if (unitMember is FunctionDeclaration) {
      print(unitMember.name.name);
    }

    if (unitMember is ClassDeclaration) {
      print(unitMember.name.name);
      for (ClassMember classMember in unitMember.members) {
        if (classMember is MethodDeclaration) {
          print('  ${classMember.name}');
        } else if (classMember is FieldDeclaration) {
          for (VariableDeclaration field in classMember.fields.variables) {
            print('  ${field.name.name}');
          }
        } else if (classMember is ConstructorDeclaration) {
          if (classMember.name == null) {
            print('  ${unitMember.name.name}');
          } else {
            print('  ${unitMember.name.name}.${classMember.name!.name}');
          }
        }
      }
    }
  }
}
