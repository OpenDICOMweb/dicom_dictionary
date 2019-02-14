// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:xml/xml.dart';

class Table {
  final String part;
  final String section;
  final String caption;
  final String label;
  final String id;
  final List<String> colNames;
  final List<String> rows;

  Table(this.part, this.section, this.caption, this.label, this.id,
      this.colNames, this.rows);

  String get title => 'Table $label. $caption';

  int get length => rows.length;

  @override
  String toString() => '$title';
}

class XmlTable {
  final XmlElement table;
  final List<XmlAttribute> attributes;

  XmlTable(this.table) : attributes = table.attributes;

  String _getAttrValue(String name) =>
      attributes.firstWhere((a) => a.name.local == 'label').value;

  String get label => _getAttrValue('label');

  String get id => _getAttrValue('xml:id');

  String get title => table.findElements('caption').single.text;

  List<String> get headers {
    final thead = table.findElements('thead');
    final ths = thead.single.findAllElements('th');

    final values = <String>[];
    for (var v in ths) {
      final td = '$v'.trim();
      if (td == '') continue;
      final value = v.text.trim();
      values.add(value);
    }
    print('$values');
    return values;
  }

  List<String> get rows {
    final tbody = table.findElements('tbody');
    final tds = tbody.single.findAllElements('td');
    print('tds(${tds.length}): $tds');
    final values = <String>[];

    for (var v in tds) {
      final td = '$v'.trim();
      if (td == '') continue;
      final value = v.text.trim();
      values.add(value);
    }
    print('$values');
    return values;
  }
}
