import 'dart:io';

String removeStyleFromBlocks(String content) {
  final patterns = [
    'style: ElevatedButton.styleFrom(',
    'style: OutlinedButton.styleFrom(',
    'style: TextButton.styleFrom(',
    'style: FilledButton.styleFrom(',
  ];

  String result = content;
  for (var pattern in patterns) {
    while (true) {
      int startIndex = result.indexOf(pattern);
      if (startIndex == -1) break;

      // Find the start of `style: `
      int lineStart = result.lastIndexOf('\n', startIndex);
      if (lineStart == -1) lineStart = 0; else lineStart += 1;
      // Get the spaces before `style:`
      String prefix = result.substring(lineStart, startIndex);
      if (prefix.trim().isNotEmpty) {
        // "style:" is not at the start of the line or has non-space chars before it
        // We just remove starting from startIndex
      } else {
        startIndex = lineStart;
      }

      int parenLevel = 0;
      int endIndex = -1;
      int searchStart = result.indexOf(pattern) + pattern.length - 1; // Position of '('
      
      for (int i = searchStart; i < result.length; i++) {
        if (result[i] == '(') parenLevel++;
        else if (result[i] == ')') {
          parenLevel--;
          if (parenLevel == 0) {
            endIndex = i;
            break;
          }
        }
      }

      if (endIndex != -1) {
        // check for trailing comma
        if (endIndex + 1 < result.length && result[endIndex + 1] == ',') {
          endIndex++;
        }
        result = result.substring(0, startIndex) + result.substring(endIndex + 1);
      } else {
        break; // Error parsing
      }
    }
  }
  return result;
}

void main() {
  final dir = Directory('lib/screens');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    String original = file.readAsStringSync();
    String modified = removeStyleFromBlocks(original);
    // Suppress active_session_screen's recent OutlinedButton.
    // Wait, active_session_screen has an OutlinedButton that I WANT to keep specifically modeled!
    // But since it's the exact design from main.dart, it will inherit it!
    // Wait, the active_session_screen OutlinedButton has:
    // side: BorderSide(color: Theme.of(context).primaryColor, width: 2)
    // whereas main.dart has width 1.5. Letting it inherit is better.
    
    if (original != modified) {
      print('Updated ${file.path}');
      file.writeAsStringSync(modified);
    }
  }
}
