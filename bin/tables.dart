// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
import 'dart:io';

import 'package:xml/xml.dart' as xml;

import 'package:dcmdict/src/olinks.dart';
import 'package:dcmdict/src/lookup_table.dart';

const String part = 'part03';
const String partXml =
    'C:/odw/dicom_dictionary/standard_2018d/source/docbook/$part/$part.xml';

const String outputDir = 'C:/odw/dicom_dictionary/output';

final String thisPartLink = standardOLinks['PS3.6'];


void main() {
  final inFile = File(partXml);
  final inText = inFile.readAsStringSync();
  final document = xml.parse(inText);
  final tables = document.findAllElements('table');

  print('Part: $part');

  for (var table in tables) {
    final label = getAttribute(table, 'label');
    final id = getAttribute(table, 'xml:id');
    //Urgent fix title processing to handle links
    final title = table.findElements('caption').single.text;

    print('Table: $label');
    final sb = StringBuffer('''{ 
  "@type": "Table", 
  "label": "$label", 
  "id": "$id", 
  "title": "$title",
  ''');

    final headers = getHeaders(table);
    sb.writeln('"headers": [${_toString(headers)}],');

    final nRows = getRows(partXml, table);
    sb.write('  "rows": [\n');
    for (var i = 0; i < nRows.length - 1; i++)
      sb.write('\t[${_toString(nRows[i])}],\n');

    final lastRow = nRows[nRows.length - 1];
    sb
      ..write('\t[${_toString(lastRow)}]\n')
      ..writeln('  ]\n}\n');
    File('$outputDir/$part/$label.json').writeAsStringSync('$sb');
  }
}

// **** Urgent: remove extra spaces from V

// Returns a quoted String with newlines replaced with spaces,
// multiple spaces removed, and double quote characters escaped, e.g.\"
String _qString(String s) {
  var v = s;
  if (v.contains('\n')) {
    v = s.replaceAll('\n', ' ');
    v = v.replaceAll('\r', ' ');
    v = v.replaceAll('\t', ' ');
    v = v.replaceAll('"', '\\"');
    while (v.contains('  ')) v = v.replaceAll('  ', ' ');
    return '"$v"';
  }
  return '"$v"';
}

String _toString(List<String> list) => list.map(_qString).join(',');
