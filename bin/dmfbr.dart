import 'package:dmfbr/core/dmfbr.command.pair.dart';
import 'package:dmfbr/core/dmfbr.utils.dart';
import 'package:dmfbr/dmfbr.cli.dart';
import 'package:dmfbr/dmfbr.interfaces.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) {
  final ICLI cli = CLI();
  String dirName = '';
  String fileName = '';
  String commandName = '';
  bool isFound = false;
  // Command find
  for (int iFor = 0; iFor < arguments.length; iFor++) {
    commandName = arguments[iFor];

    if (cli.commandList.containsKey(commandName)) {
      break;
    }
  }
  // Set command executed
  cli.commandExecuted = commandName;
  // Command list
  final Map<String, CommandPair> argumentList = cli.commandList[cli.commandExecuted] ?? {};
  // Argument find
  for (int iFor = 0; iFor < arguments.length; iFor++) {
    final String argName = arguments[iFor];

    if (argumentList.containsKey(argName)) {
      cli.argumentList.add(argName);
    } else if (cli.options.containsKey(argName)) {
      cli.options[argName] = true;
    } else {
      dirName = path.dirname(arguments[iFor]);
      fileName = path.basename(arguments[iFor]);
      if (dirName == '.') {
        dirName = '$dirName/$fileName';
      }
    }
  }
  // Command execute
  for (final String key in cli.argumentList) {
    if (argumentList[key]?.value == null) {
      continue;
    }
    final ICommand? resultExecute = argumentList[key]?.value?.execute(dirName, fileName, cli);
    if (resultExecute != null) {
      isFound = true;
    }
  }
  if (!isFound) {
    Utils.printAlert('Error: unknown command "${cli.commandExecuted}" for "dmfbr"');
    Utils.printAlert('Run \'dmfbr --help\' for usage.');
  }
}
