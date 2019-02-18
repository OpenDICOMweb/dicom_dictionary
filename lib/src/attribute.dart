// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// ignore_for_file: public_member_api_docs
// ignore_for_file: type_annotate_public_apis

class AType {
  final String name;
  final int index;

  const AType(this.name, this.index);

  static const $1 = AType('required value', 0);
  static const $1C = AType('conditionally required value', 1);
  static const $2 = AType('required element', 2);
  static const $2C = AType('conditionally required element', 3);
  static const $3 = AType('optional', 4);
}

class Attribute {
  final String name;
  final int code;
  final AType aType;
  final String description;

  const Attribute(this.name, this.code, this.aType, this.description);
}

class Sequence extends Attribute {
  final List<Item> items;

  const Sequence(
      String name, int code, AType aType, String description, this.items)
      : super(name, code, aType, description);
}

class Item {
  final List<Attribute> attributes;

  const Item(this.attributes);
}

class Macro {
  final String part;
  final String table;
  final String name;
  final List<Attribute> attributes;

  const Macro(this.part, this.table, this.name, this.attributes);

}

class Module {
  final String part;
  final String table;
  final String name;
  final List<Attribute> attributes;
  final List<Macro> macros;

  const Module(this.part, this.table, this.name, this.attributes, this.macros);

}

class AttributeDictionary {

}
