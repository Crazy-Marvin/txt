import 'package:flutter/material.dart';
import 'package:txt/model/note.dart';
import 'package:txt/widget/txt_icons.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  const NoteTile(this.note, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      leading: Column(
        children: [
          Builder(builder: (_) {
            var icon;
            switch (note.type) {
              case NoteType.Txt:
                icon = TxtIcons.fileText;
                break;
              case NoteType.Md:
                icon = TxtIcons.fileMarkdown;
                break;
            }
            return Icon(icon);
          }),
          Spacer(),
        ],
      ),
      title: Text(
        note.title,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .apply(color: Theme.of(context).accentColor),
      ),
      subtitle: FutureBuilder(
        future: note.excerpt,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return Text(
            snapshot.data,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
}
