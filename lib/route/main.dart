import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:txt/model/note.dart';
import 'package:txt/themes.dart';
import 'package:txt/widget/main_menu.dart';
import 'package:txt/widget/note_list.dart';
import 'package:txt/widget/note_sort_menu.dart';
import 'package:txt/widget/system_ui.dart';
import 'package:txt/widget/txt_icons.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NoteState _noteState = NoteState.Normal;
  NoteType _noteType;
  NoteSort _noteOrder = NoteSort.Title;

  void _showMenu() {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) => MainMenu(
        noteState: _noteState,
        noteStateCallback: (state) {
          Navigator.of(context).pop();
          setState(() {
            _noteState = state;
          });
        },
        noteTagCallback: (tag) {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      builder: (builder) => NoteSortMenu(
        noteOrder: _noteOrder,
        noteOrderCallback: (order) {
          Navigator.of(context).pop();
          setState(() {
            _noteOrder = order;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).withTranslucentAppBar(),
      child: Builder(
        builder: (BuildContext context) {
          return SystemUiOverlayRegion(
            child: RefreshIndicator(
              onRefresh: () async {},
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'txt'.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  leading: Icon(TxtIcons.blank),
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(TxtIcons.drawer),
                        onPressed: () => _showMenu(),
                      ),
                      IconButton(
                        icon: Icon(TxtIcons.filter),
                        onPressed: () => _showSortMenu(),
                      ),
                    ],
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Builder(
                  builder: (context) {
                    return FloatingActionButton.extended(
                      onPressed: () {
                        final snackBar =
                            SnackBar(content: Text('Create new file.'));
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      label: Text('New draft'.toUpperCase()),
                      icon: Icon(TxtIcons.add),
                    );
                  },
                ),
                body: NoteList(
                  state: _noteState,
                  type: _noteType,
                  sort: _noteOrder,
                ),
              ),
            ),
            builder: (context) => Theme.of(context).systemUiOverlayStyle(
              hasTopAppBar: false,
              hasBottomAppBar: true,
            ),
          );
        },
      ),
    );
  }
}
