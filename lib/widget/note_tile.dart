import 'package:flutter/material.dart';
import 'package:txt/model/note.dart';
import 'package:txt/widget/txt_icons.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  const NoteTile(this.note, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Builder(builder: (context) {
        switch (note.type) {
          case NoteType.Txt:
            return Icon(TxtIcons.fileText);
          case NoteType.Md:
            return Icon(TxtIcons.fileMarkdown);
        }
        throw "Unknown note type: '${note.type}'.";
      }),
      title: Text(note.title),
      subtitle: FutureBuilder(
        future: note.excerpt,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return Text(snapshot.data);
        },
      ),
    );
  }
}
