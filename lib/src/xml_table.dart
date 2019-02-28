// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:xml/xml.dart';

/// An XML Table.
class Table {
  /// The [part] of the DICOM Standard containing _this_.
  final String part;
  /// The [section] of the Part of the DICOM Standard containing _this_.
  final String section;
  /// The [caption] of _this_.
  final String caption;
  /// The [label] of _this_.
  final String label;
  /// The [id] of _this_.
  final String id;
  /// The [List] of column names of _this_.
  final List<String> colNames;
  /// The [List] of Rows of _this_.
  final List<String> rows;

  /// Constructor
  Table(this.part, this.section, this.caption, this.label, this.id,
      this.colNames, this.rows);

  /// The XML Title of _this_.
  String get title => 'Table $label. $caption';

  /// The number of Rows in _this_.
  int get length => rows.length;

  @override
  String toString() => '$title';
}

/// An XML Table Element
class XmlTable {
  /// The Table Element.
  final XmlElement table;
  /// The attributes of _this_.
  final List<XmlAttribute> attributes;

  /// Constructor
  XmlTable(this.table) : attributes = table.attributes;

  String _getAttrValue(String name) =>
      attributes.firstWhere((a) => a.name.local == 'label').value;

  /// The XML label for _this_
  String get label => _getAttrValue('label');

  /// The XML id for _this_.
  String get id => _getAttrValue('xml:id');

  /// The XML title of _this_
  String get title => table.findElements('caption').single.text;

  /// The XML headers for _this_.
  List<String> get headers {
    final thead = table.findElements('thead');
    final ths = thead.single.findAllElements('th');

    final values = <String>[];
    for (final v in ths) {
      final td = '$v'.trim();
      if (td == '') continue;
      final value = v.text.trim();
      values.add(value);
    }
    print('$values');
    return values;
  }

  /// The table's rows.
  List<String> get rows {
    final tbody = table.findElements('tbody');
    final tds = tbody.single.findAllElements('td');
    print('tds(${tds.length}): $tds');
    final values = <String>[];

    for (final v in tds) {
      final td = '$v'.trim();
      if (td == '') continue;
      final value = v.text.trim();
      values.add(value);
    }
    print('$values');
    return values;
  }
}
