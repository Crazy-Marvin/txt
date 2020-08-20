import 'package:flutter/material.dart';
import 'package:txt/model/note.dart';
import 'package:txt/widget/txt_icons.dart';

typedef NoteSortCallback = Function(NoteSort order);
typedef NoteFilterCallback = Function(NoteType type);

class NoteSortMenu extends StatelessWidget {
  final NoteSort noteOrder;
  final NoteSortCallback noteOrderCallback;

  const NoteSortMenu({
    Key key,
    this.noteOrder,
    @required this.noteOrderCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: Theme.of(context).bottomSheetTheme.shape,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("Sort by"),
            enabled: false,
          ),
          _NoteSortTile(
            tileNoteSort: NoteSort.LastModified,
            noteSort: noteOrder,
            noteSortCallback: noteOrderCallback,
          ),
          _NoteSortTile(
            tileNoteSort: NoteSort.Title,
            noteSort: noteOrder,
            noteSortCallback: noteOrderCallback,
          ),
        ],
      ),
    );
  }
}

class _NoteSortTile extends StatelessWidget {
  final NoteSort tileNoteSort;
  final NoteSort noteSort;
  final NoteSortCallback noteSortCallback;

  const _NoteSortTile({
    Key key,
    @required this.tileNoteSort,
    this.noteSort,
    @required this.noteSortCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (noteSort == tileNoteSort) {
      trailing = Icon(Icons.check); // TODO replace with TxtIcons variant.
    }
    String title;
    IconData icon;
    switch (tileNoteSort) {
      case NoteSort.Title:
        title = 'Title (A-Z)';
        icon = TxtIcons.sortAz;
        break;
      case NoteSort.LastModified:
        title = 'Last edited';
        icon = TxtIcons.sortTime;
        break;
    }
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        return noteSortCallback(tileNoteSort);
      },
      trailing: trailing,
    );
  }
}
