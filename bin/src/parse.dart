import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class CollecData {
  final varList = <VariableDeclaration>[];

  final classList = <ClassDeclaration>[];
}

CollecData processFile(AnalysisSession session, String path) {
  // final providersList = <VariableDeclaration>[];

  var result = session.getParsedUnit(path);

  if (result is ParsedUnitResult) {
    CompilationUnit unit = result.unit;
    unit.visitChildren(IfCounter());

    // providersList.forEach((element) {
    //   print(element.name);
    // });

    // printMembers(unit);

  }

  return collecData;
}

const classCheckList = ['StatelessWidget', 'HookWidget', 'StatefulWidget'];
final collecData = CollecData();

class IfCounter extends SimpleAstVisitor<void> {
  // final CollecData collecData;

  // IfCounter(this.collecData);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    for (final item in classCheckList) {
      if (node.extendsClause.toString().contains(item)) {
        collecData.classList.add(node);
      }
    }
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    // print('------ ${node.variables.type}');

    for (var element in node.variables.variables) {
      // if (element.name.toString().contains('Provider')) {
      if (element.initializer.toString().contains('Provider')) {
        collecData.varList.add(element);
      }

      //   print(element.name);
      // print(element.initializer);
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
