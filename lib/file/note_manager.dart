import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:txt/model/note.dart';
import 'package:txt/util/file_extension.dart';

enum NotesOrder { Title, LastModified }

extension SC on File {
  _sampleContentIfEmpty() {
    if (this.lengthSync() > 0) return;
    switch (Note(this).type) {
      case NoteType.Txt:
        writeAsStringSync(
            """Lorem markdownum spatiantia dextraque innocuos quoque datque adhuc.
Inexperrectus amor Peucetiosque Halesi fessos census congestaque ramos latices
vero, similisque! Nec Achelous fidesque sine,
flammiferas nota. Nec corpora, stetit repulsa
orantemque caelum in videns ademi fraxinus successit tamen versae visus; ego
temerasse!""");
        return;
      case NoteType.Md:
        writeAsStringSync(
            """# Tenet corpusque signa funera precibusque Aestas sibi

## Crepuscula vestris hoc inque sic ferrum secreta

Lorem markdownum spatiantia dextraque innocuos quoque datque adhuc.
Inexperrectus amor Peucetiosque Halesi fessos census congestaque ramos latices
vero, similisque! Nec Achelous [fidesque sine](http://cum-maerent.com/),
flammiferas nota. Nec [corpora](http://ultima.io/mea-non.php), stetit repulsa
orantemque caelum in videns ademi fraxinus successit tamen versae visus; *ego
temerasse*!

Olivae non, in per, humo sucis te altis. Abit videt situ natisque ferrea,
animal, incedit attulit quaque. Tum passu secutum penetrabit alios! Silicem nam
tauros, dux trabes vivere auctor tertius poenamque nunc et *invisosque cursum*,
missos. Hanc adductaque sumus deflevere longoque albida: exauditi ad vidit nec.

1. Viribus flumen
2. Phoebus amborum
3. Genetrix ab nuda horret hac
4. Vidistis inclusa fatali resimas Achillis
5. Nec avertens sederunt preces
6. A agros spectem se mihi

## Dapes cui

Tum ite circumfluit proditus iubet. Pars fortis misit **nisi quicquid**: imas
non ego Duxerat removere componar Cyanee, cthonius Latonam mediis vetustas. Ad
tegemus! Sed illis nec quod, bello torreri sentit me demittit. Non in *incumbens
cava Prima* litore.

    var ipod_record = hard - motherboard;
    var pipeline_kibibyte_wiki = fiber;
    soft_import = bankruptcyUnicodeMouse(spiderVdu(technologyIbmSata,
            oop_mainframe, microphone) + clobNui(printer, solid,
            gate_metal_full), ivrZoneFavicon.socket_boot_golden(trackback), 35);

Sed nulla dent ingens, frigidus. Matura neve ignotum eo bibuntur gentis casus
mactatur crescere vulnera cogit munera, frustra tempore tamque *Pyrrham*. Agitur
saetigeri stipite veniebat moderato longo sic atque timidasque vocem genu, enim
hic premens utque. Nuruumque mediis insequeris odissem, que signis en inque
dexterior, magni: sermone usus!

1. Regia plus infecta
2. Malum reduxit timorque gregibus vicinia fetum
3. Has Pleuronius
4. In disiecta coxerat cumque
5. Et conscia confessus figuras sceleris cedere

Nec raptor ortu conceperat fessa optat dolentem [carinae
digitos](http://baculi-lycisce.net/caeso.html) iacebas: deus. Proxima sagittis
sive oscula haesit lacerti possidet pectoris Phoebus solida vultuque. Qui
ignibus inquit dantibus et *tumulos* enumerare me quae gentisque iussit; neque
sucis ille abdidit.""");
        return;
    }
  }
}

class NoteManager {
  static Future<Directory> _notesDir() async {
    var applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    var notesDirectory =
        Directory(join(applicationDocumentsDirectory.path, "notes"))
          ..createIfNotExists();

    File(join(notesDirectory.path, "test1..normal.md"))
      ..createIfNotExists()
      .._sampleContentIfEmpty();
    File(join(notesDirectory.path, "test2.foo bar.normal.txt"))
      ..createIfNotExists()
      .._sampleContentIfEmpty();
    File(join(notesDirectory.path, "test2.foo.bar.normal.txt"))
      ..createIfNotExists()
      .._sampleContentIfEmpty();
    File(join(notesDirectory.path, "test3.foo.archive.md"))
      ..createIfNotExists()
      .._sampleContentIfEmpty();
    File(join(notesDirectory.path, "test4..trash.md"))
      ..createIfNotExists()
      .._sampleContentIfEmpty();
    File(join(notesDirectory.path, "test5.bar.normal.md"))
      ..createIfNotExists()
      .._sampleContentIfEmpty();

    return notesDirectory;
  }

  static Future<List<Note>> list(
      {NoteState state, NoteType type, NotesOrder order}) async {
    Directory notesDir = await _notesDir();
    Iterable<Note> notes = notesDir.listSync().map((file) => Note(file));
    if (state != null) {
      notes = notes.where((note) => note.state == state);
    }
    if (type != null) {
      notes = notes.where((note) => note.type == type);
    }
    if (order != null) {
      List<Note> notesList = notes.toList();
      notesList.sort((a, b) {
        switch (order) {
          case NotesOrder.Title:
            return a.title.compareTo(b.title);
          case NotesOrder.LastModified:
            return -a.file
                .lastModifiedSync()
                .compareTo(b.file.lastModifiedSync());
        }
        return 0;
      });
      notes = notesList;
    }
    return notes.toList();
  }

  static Future add() async {
    Directory notesDir = await _notesDir();
  }

  static Future delete(Note note) async {
    Directory notesDir = await _notesDir();
  }
}
