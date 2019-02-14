// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
import 'dart:io';

import 'package:xml/xml.dart' as xml;

import 'package:dcmdict/src/olinks.dart';
import 'package:dcmdict/src/lookup_table.dart';

const String part6xml =
    'C:/odw/dicom_dictionary/standard_2018d/source/docbook/part06/part06.xml';

final String thisPartLink = standardOLinks['PS3.6'];

void main() {
  final inFile = File(part6xml);
  final inText = inFile.readAsStringSync();
  final document = xml.parse(inText);
  final tables = document.findAllElements('table');
  print('N Tables: ${tables.length}');

  var n = 0;
  for (var table in tables) {
    final label = getAttribute(table, 'label');
    final id = getAttribute(table, 'xml:id');
    final title = table.findElements('caption').single.text;
    print('$n Table $label: "$id" "$title"');

    final headers = getHeaders(table);
    print('\theaders(${headers.length}): $headers');

    final nRows = getRows(part6xml, table);
    print('\tRows(${nRows.length}): ${nRows.join('\n\t')}\n');
    n++;
  }
}


