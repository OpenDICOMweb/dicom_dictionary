// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:io';

import 'package:xml/xml.dart' as xml;

import 'package:dcmdict/src/olinks.dart';

/// Get an XML Table with [tableId] from a [part] of the DICOM Standard.
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

/// Get the XML Attribute with [name] from [e].
String getAttribute(xml.XmlElement e, String name) {
  final attrs = e.attributes;
  final a = attrs.firstWhere((x) => x.name.toString() == name);
  return a.value;
}

/// Get the XML Attribute with [name] from [list].
List<String> getAttributeList(Iterable<xml.XmlElement> list, String name) {
  final result = <String>[];
  for (var e in list) result.add(getAttribute(e, name));
  return result;
}

/// Get the XML Table Headers from [table].
List<String> getHeaders(xml.XmlElement table) {
  final tHead = table.findElements('thead');
  if (tHead.isEmpty) return <String>[];
  var ths = tHead.single.findAllElements('th');
  if (ths.isEmpty) ths = tHead.single.findAllElements('td');
  final values = <String>[];

  for (var e in ths) {
    final value = e.text.trim();
    values.add(value);
  }
  return values;
}

/// Get the XML Rows from [table] in [part] of the DICOM Standard.
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

      if (isInclude(text)) {
       // print('include: "$td"');
        print('Include xref: ${td.findAllElements('xref')}');
      }

      final oLinks = td.findAllElements('olink');
      if (oLinks != null && oLinks.isNotEmpty) {
        final slink = standardOLinks[getAttributeList(oLinks, 'targetdoc')];
        final ptr = getAttributeList(oLinks, 'targetptr');
        oLink = '|$slink#$ptr';
      }

      final links = td.findAllElements('link');
      if (links != null && links.isNotEmpty) {
        print('links: $links');
        final gLink = getAttributeList(links, 'xl:href');
        link = '|$gLink';
      }

      final xrefs = td.findAllElements('xref');
      if (xrefs != null && xrefs.isNotEmpty) {
//        print('xrefs: $xrefs');
//        final linkEnd = getAttribute(xrefs.single, 'linkend');
        final links = getAttributeList(xrefs, 'linkend');
//        final result = <String>[];
        for (var linkEnd in links) {
//        final linkEnd =
          text = 'sect_'.matchAsPrefix(linkEnd) == null
              ? linkEnd.substring(5)
              : linkEnd;
//        print('X: $text');
          link = '|$part#$linkEnd';
        }
      }
      final v = '$text$oLink$link';
//      print(v);
      values.add(v);
    }
    rows.add(values);
  }
  return rows;
}

/// Returns true if [s] is a Tag code.
bool isTag(String s) =>
    s.length == 11 && s[0] == '(' && s[5] == ',' && s[10] == ')';

/// Returns truw if [s] is an include row.
bool isInclude(String s) {
  for (var i = 0; i < s.length; i++) {
    if (s[i] == '>') continue;

    final v = s.substring(i);
    if (v.startsWith('Include')) print('v: "$v"');
    return v.startsWith('Include');
  }
  return false;
}

/// Return a hexadecimal [String] corresponding to [tag].
String tagToHex(String tag) {
  if (!isTag(tag)) return null;
  var hex = tag.replaceFirst('(', '');
  hex = hex.replaceFirst(',', '');
  hex = hex.replaceFirst(')', '');
  return '0x$hex';
}

/// Returns the XML Element with [label] from [elements].
xml.XmlElement elementWithLabel(List<xml.XmlElement> elements, String label) {
  for (var e in elements) {
    final name = getAttribute(e, 'label');
    if (name == label) return e;
  }
  return null;
}
