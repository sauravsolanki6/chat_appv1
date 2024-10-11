import 'package:flutter/material.dart';

import '../network/response/getchatresponse.dart';

class MessageSelectionModel extends ChangeNotifier {
  List<int> selectedIndexes = [];

  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
    notifyListeners();
  }

  void setFirstSelection(int index) {
    selectedIndexes.clear();
    selectedIndexes.add(index);
    notifyListeners();
  }

  bool isSelected(int index) {
    return selectedIndexes.contains(index);
  }

  List<int> getSelectedIndexes() {
    return selectedIndexes;
  }

  void clearSelection() {
    selectedIndexes.clear();
    notifyListeners();
  }

  List<Messagejson> getSelectedMessages(List<Messagejson> messages) {
    return selectedIndexes.map((index) => messages[index]).toList();
  }
}
