import 'package:flutter/material.dart';
import 'package:txt/file/note_manager.dart';
import 'package:txt/model/note.dart';

import 'note_tile.dart';

@immutable
class NoteList extends StatelessWidget {
  final NoteState state;
  final NoteType type;
  final String tag;
  final NoteSort sort;

  const NoteList({
    Key key,
    this.state,
    this.type,
    this.tag,
    @required this.sort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NoteManager.list(state: state, type: type, tag: tag, sort: sort),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Note> notes = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              if (index >= 1 + notes.length + (notes.length - 1)) return null;
              if (index.isEven) {
                if (index == 0)
                  return SizedBox(height: 16);
                else
                  return Divider(
                    indent: 72,
                  );
              }
              return Column(
                children: [
                  NoteTile(notes[index ~/ 2]),
                ],
              );
            },
          );
        } else {
          return SingleChildScrollView(
            child: Container(),
          );
        }
      },
    );
  }
}
