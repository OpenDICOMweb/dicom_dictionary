// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
//
import 'dart:io';

import 'package:xml/xml.dart' as xml;

import 'package:dcmdict/src/olinks.dart';

xml.XmlElement getTable(String part, String tableId) {
  final inFile = File(part);
  final inText = inFile.readAsStringSync();
  final document = xml.parse(inText);
  final tables = document.findAllElements('table');

  for (var table in tables) {
    final v = getAttribute(table, 'xml:id');
    if (v == tableId) return table;
  }
  return null;
}

String getAttribute(xml.XmlElement e, String name) {
  final attrs = e.attributes;
  final a = attrs.firstWhere((x) => x.name.toString() == name);
  return a.value;
}

List<String> getHeaders(xml.XmlElement table) {
  final tHead = table.findElements('thead');
  final ths = tHead.single.findAllElements('th');
  final values = <String>[];

  for (var e in ths) {
    final value = e.text.trim();
    values.add(value);
  }
  return values;
}

List<List<String>> getRows(String part, xml.XmlElement table) {
  final tBody = table.findElements('tbody');
  final trs = tBody.single.findAllElements('tr');
  final rows = <List<String>>[];
  for (var row in trs) {
    final tds = row.findAllElements('td');
    final values = <String>[];
    for (var td in tds) {
      // TODO: handle multiple paragraphs
///      final para = td.findAllElements('para');
//      if (para != null && para.isNotEmpty) {
//        final paraId = para.single.getAttribute('xml:id');
//      }
      var oLink = '';
      var link = '';
      var text = td.text.trim();
      if (isTag(text)) text = tagToHex(text);

      final olinks = td.findAllElements('olink');
      if (olinks != null && olinks.isNotEmpty) {
        final slink = standardOLinks[getAttribute(olinks.single, 'targetdoc')];
        final ptr = getAttribute(olinks.single, 'targetptr');
        oLink = '|$slink#$ptr';
      }

      final links = td.findAllElements('link');
      if (links != null && links.isNotEmpty) {
        final gLink = getAttribute(links.single, 'xl:href');
        link = '|$gLink';
      }

      final xrefs = td.findAllElements('xref');
      if (xrefs != null && xrefs.isNotEmpty) {
        final linkEnd = getAttribute(xrefs.single, 'linkend');
        text = 'sect_'.matchAsPrefix(linkEnd) == null
            ? linkEnd.substring(5)
            : linkEnd;
//        print('X: $text');
        link = '|$part#$linkEnd';
      }
      final v = '$text$oLink$link';
//      print(v);
      values.add(v);
    }

    rows.add(values);
  }
  return rows;
}

bool isTag(String s) =>
    s.length == 11 && s[0] == '(' && s[5] == ',' && s[10] == ')';

String tagToHex(String tag) {
  if (!isTag(tag)) throw 'Invalid Tag: "$tag"';
  var hex = tag.replaceFirst('(', '');
  hex = hex.replaceFirst(',', '');
  hex = hex.replaceFirst(')', '');
  return '0x$hex';
}

xml.XmlElement elementWithLabel(List<xml.XmlElement> elements, String label) {
  for (var e in elements) {
    final name = getAttribute(e, 'label');
    if (name == label) return e;
  }
  return null;
}

