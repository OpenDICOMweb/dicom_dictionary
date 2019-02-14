// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
import 'dart:io';

import 'package:xml2json/xml2json.dart';

const String part6xml =
    'C:/odw/dicom_dictionary/standard_2018d/source/docbook/part06/part06.xml';

void main() {
  // Create a client transformer
  final myTransformer = Xml2Json();

  final inFile = File(part6xml);
  final inText = inFile.readAsStringSync();

  // Parse a simple XML string
  myTransformer.parse(inText);
  print('XML string');
  print(myTransformer.xmlParserResult);
  print('');

  // Transform to JSON using Badgerfish
  var json = myTransformer.toBadgerfish();
  print('Badgerfish');
  print('');
  print(json);
  print('');

  // Transform to JSON using GData
  json = myTransformer.toGData();
  print('GData');
  print('');
  print(json);
  print('');

  // Transform to JSON using Parker
  json = myTransformer.toParker();
  print('Parker');
  print('');
  print(json);
}
