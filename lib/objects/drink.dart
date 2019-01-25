import 'dart:convert';

import 'package:bierzaehler/objects/size.dart';
import 'package:bierzaehler/objects/use.dart';

///Represents a Drink.
class Drink {
  String _name;
  double _alcohol;

  List<Size> _sizes;
  List<Use> _uses;

  ///Creates the object.
  ///
  ///[_name] the name of the drink.
  ///[_alcohol] the vol% of the drink.
  ///[_sizes] a list of sizes where belong to the drink.
  ///[_uses] a list of uses of the drink.
  Drink(drinkName, drinkAlcohol, drinkSizes, drinkUses) {
    name = drinkName;
    alcohol = drinkAlcohol;
    _drinkSizes = drinkSizes;
    _drinkUses = drinkUses;
  }

  ///Creates the drink and all child objects from JSON.
  ///
  ///[data] the data in Map format.
  ///Throws an [ArgumentError] if the data is invalid.
  Drink.fromJSON(Map<String, dynamic> data) {
    if (data["name"] != null && data["name"] is String) {
      this._name = data["name"];
    } else {
      throw ArgumentError("name was invalid!");
    }
    if (data["alcohol"] != null && data["alcohol"] is String) {
      this._alcohol = double.parse(data["alcohol"]);
    } else {
      throw ArgumentError("alcohol was invalid!");
    }
    if (data["sizes"] != null) {
      Iterable l = jsonDecode(data["sizes"]);
      _sizes = l.map((model) => Size.fromJSON(model)).toList();
    } else {
      throw ArgumentError("sizes was invalid!");
    }
    if (data["uses"] != null) {
      Iterable l = jsonDecode(data["uses"]);
      _uses = l.map((model) => Use.fromJSON(model)).toList();
    } else {
      throw ArgumentError("sizes was invalid!");
    }
  }

  Map<String, dynamic> toJson() => {
        "name": _name,
        "alcohol": _alcohol.toString(),
        "sizes": jsonEncode(_sizes),
        "uses": jsonEncode(_uses)
      };

  //-------------------------------
  //PUBLIC METHODS
  //-------------------------------

  ///Drink now a specific amount.
  ///
  ///[sizeIndex] the index of the Size in the sizes list.
  ///Throws an [ArgumentError] if sizeIndex is invalid.
  void doUse(int sizeIndex) {
    if (sizeIndex < 0 || sizeIndex >= _sizes.length) {
      throw ArgumentError(
          "sizeIndex out of boundaries! sizeIndex: " + sizeIndex.toString());
    }
    _uses.add(new Use(_sizes[sizeIndex]));
  }

  ///Adds a the size to the list of sizes.
  ///
  ///[size] the size to add.
  ///Throws an [ArgumentError] if size is null or
  ///size is already in the list.
  void addSize(Size size) {
    if (size == null) {
      throw ArgumentError('size is null');
    }
    for (Size sizeA in _sizes) {
      if (identical(size, sizeA)) {
        throw ArgumentError('size is already in array');
      }
    }
    _sizes.add(size);
  }

  ///Removes the size from the list.
  ///
  /// [size] the size to delete.
  /// Throws an [ArgumentError] if the size is null or
  /// the size is not in the list.
  void removeSize(Size size) {
    if (size == null) {
      throw ArgumentError("size is null");
    }
    if (!_sizes.remove(size)) {
      throw ArgumentError("The size was not in the list!");
    }
  }

  ///Removes the size on index [sizeIndex] from the list.
  ///
  /// [sizeIndex] the size on sizeIndex to delete.
  /// Throws an [ArgumentError] if the sizeIndex is invalid.
  void removeSizeAt(int sizeIndex) {
    if (_sizes.removeAt(sizeIndex) == null) {
      throw ArgumentError("The size was not in the list!");
    }
  }

  ///Set the Name.
  ///
  ///[name] the name to set.
  set name(String name) {
    if (name == null) {
      throw ArgumentError("name was null!");
    }
    this._name = name;
  }

  ///Set the Alcohol.
  ///
  ///[alcohol] the alcohol to set.
  set alcohol(double alcohol) {
    if (alcohol == null) {
      throw ArgumentError("alcohol was null!");
    }
    this._alcohol = alcohol;
  }

  ///Removes the last Element of the list of uses.
  bool removeLastUse() {
    return (this._uses.removeLast() != null);
  }

  get name => _name;

  get alcohol => _alcohol;

  get uses {
    return new List<Use>.from(_uses);
  }

  get sizes {
    return new List<Size>.from(_sizes);
  }

  //--------------------------------------
  //PRIVATE FUNCTIONS
  //--------------------------------------

  ///Set the Uses
  ///
  ///[uses] the list of uses to set.
  ///Throws an [ArgumentError] if uses is null or
  ///if uses is an unmodifiable list.
  set _drinkUses(List<Use> uses) {
    if (uses != null) {
      Use use = new Use(new Size(0.0));
      uses.add(use);
      if (!uses.remove(use)) {
        throw ArgumentError("uses list is unmodifiable!");
      }
      this._uses = uses;
    } else {
      throw ArgumentError("uses was null!");
    }
  }

  ///Set the Sizes
  ///
  ///[uses] the list of uses to set.
  ///Throws an [ArgumentError] if uses is null or
  ///if uses is an unmodifiable list.
  set _drinkSizes(List<Size> sizes) {
    if (sizes != null) {
      Size size = new Size(0.0);
      sizes.add(size);
      if (!sizes.remove(size)) {
        throw ArgumentError("sizes list is unmodifiable!");
      }
      this._sizes = sizes;
    } else {
      throw ArgumentError("sizes was null!");
    }
  }

  get amount{
    double result = 0.0;
    for(Use use in _uses){
      result += use.size.value;
    }
    return result;
  }
}
