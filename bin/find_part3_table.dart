// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
import 'dart:io';

import 'package:xml/xml.dart' as xml;

import 'package:dcmdict/src/olinks.dart';
import 'package:dcmdict/src/lookup_table.dart';

const String part3xml =
    'C:/odw/dicom_dictionary/standard_2018d/source/docbook/part03/part03.xml';

final String thisPartLink = standardOLinks['PS3.6'];

void main() {
  final inFile = File(part3xml);
  final inText = inFile.readAsStringSync();
  final document = xml.parse(inText);
  final tables = document.findAllElements('table');
  print('N Tables: ${tables.length}');

  const id = 'table_C.7-1';
  final table = getTable(part3xml, id);
  final headers = getHeaders(table);
  final rows = getRows(part3, table);

  print('table: $id');
  print('\theaders(${headers.length}): $headers');
  print('\tRows(${rows.length}): ${rows.join('\n\t')}\n');
}


