import 'package:markdown/markdown.dart';
import 'package:txt/markdown_sample.dart';

void main() {
  var markdown = markdownSample;
  var document = Document(
    extensionSet: ExtensionSet.gitHubFlavored,
  );
  var nodes =
      document.parseLines(markdown.replaceAll('\r\n', '\n').split('\n'));
  var renderer = HtmlRenderer();
  var html = renderer.render(nodes);
  print(html);
}
