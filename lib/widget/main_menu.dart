import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:txt/file/note_manager.dart';
import 'package:txt/model/note.dart';
import 'package:txt/route/settings.dart';
import 'package:txt/widget/txt_icons.dart';

typedef NoteStateCallback = Function(NoteState state);
typedef NoteTagCallback = Function(String tag);

@immutable
class MainMenu extends StatelessWidget {
  final NoteState noteState;
  final NoteStateCallback noteStateCallback;
  final String noteTag;
  final NoteTagCallback noteTagCallback;

  const MainMenu({
    Key key,
    this.noteState,
    @required this.noteStateCallback,
    this.noteTag,
    @required this.noteTagCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: Theme.of(context).bottomSheetTheme.shape,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 2 / 3,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
          ),
          child: FutureBuilder(
            future: NoteManager.listTags(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _MainMenuList(
                  noteState: noteState,
                  noteStateCallback: noteStateCallback,
                  noteTag: noteTag,
                  noteTagCallback: noteTagCallback,
                  tags: snapshot.data,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _MainMenuList extends StatelessWidget {
  final NoteState noteState;
  @required
  final NoteStateCallback noteStateCallback;
  final String noteTag;
  @required
  final NoteTagCallback noteTagCallback;
  final Set<String> tags;
  final ScrollController controller;

  const _MainMenuList({
    Key key,
    this.noteState,
    this.noteStateCallback,
    this.noteTag,
    this.noteTagCallback,
    this.tags,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        List<NoteState> states = NoteState.values;
        List<String> tags = this.tags.toList() ?? [];
        int tagDividerCount = tags.length.clamp(0, 1);
        if (index < 1) {
          return ListTile(
            leading: Icon(
              TxtIcons.blank,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            title: Builder(builder: (context) {
              ThemeData theme = Theme.of(context);
              return Text(
                'John Doe'.toUpperCase(),
                style: theme.textTheme.headline6.copyWith(
                  fontSize: theme.textTheme.subtitle1.fontSize,
                ),
              );
            }),
          );
        } else if (index < 2) {
          return Divider(indent: 72);
        } else if (index < 2 + states.length) {
          return _NoteStateTile(
            tileNoteState: states[index - 2],
            noteState: noteState,
            noteStateCallback: noteStateCallback,
          );
        } else if (index < 2 + states.length + 1) {
          return Divider(indent: 72);
        } else if (index < 2 + states.length + 1 + tags.length) {
          return _NoteTagTile(
            tileNoteTag: tags[index - 2 - states.length - 1],
            noteTag: noteTag,
            noteTagCallback: noteTagCallback,
          );
        } else if (index <
            2 + states.length + 1 + tags.length + tagDividerCount) {
          return Divider(indent: 72);
        } else if (index <
            2 + states.length + 1 + tags.length + tagDividerCount + 1) {
          return ListTile(
            leading: Icon(TxtIcons.edit),
            title: Text('Edit labels'),
          );
        } else if (index <
            2 + states.length + 1 + tags.length + tagDividerCount + 1 + 1) {
          return ListTile(
            leading: Icon(TxtIcons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          );
        } else {
          return null;
        }
      },
    );
  }
}

class _NoteStateTile extends StatelessWidget {
  final NoteState tileNoteState;
  final NoteState noteState;
  final NoteStateCallback noteStateCallback;

  const _NoteStateTile({
    Key key,
    @required this.tileNoteState,
    this.noteState,
    @required this.noteStateCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (noteState == tileNoteState) {
      trailing = Icon(Icons.check); // TODO replace with TxtIcons variant.
    }
    String title;
    IconData icon;
    switch (tileNoteState) {
      case NoteState.Normal:
        title = 'All drafts';
        icon = TxtIcons.document;
        break;
      case NoteState.Archived:
        title = 'Archive';
        icon = TxtIcons.archive;
        break;
      case NoteState.Trashed:
        title = 'Trash';
        icon = TxtIcons.trash;
        break;
    }
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        return noteStateCallback(tileNoteState);
      },
      trailing: trailing,
    );
  }
}

class _NoteTagTile extends StatelessWidget {
  final String tileNoteTag;
  final String noteTag;
  final NoteTagCallback noteTagCallback;

  const _NoteTagTile({
    Key key,
    @required this.tileNoteTag,
    this.noteTag,
    @required this.noteTagCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (noteTag == tileNoteTag) {
      trailing = Icon(Icons.check); // TODO replace with TxtIcons variant.
    }
    Color color = Colors.accents[tileNoteTag.hashCode % Colors.accents.length];
    return ListTileTheme(
      textColor: color,
      iconColor: color,
      child: ListTile(
        leading: Icon(TxtIcons.label),
        title: Text(tileNoteTag),
        onTap: () {
          return noteTagCallback(tileNoteTag);
        },
        trailing: trailing,
      ),
    );
  }
}
