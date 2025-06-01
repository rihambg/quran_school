import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';

import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/api_client.dart';

class MultiSelectResult {
  List<MultiSelectItem>? items;
  String? errorMessage;
  MultiSelectResult.onSuccess({required this.items}) : errorMessage = null;
  MultiSelectResult.onError({required this.errorMessage}) : items = null;
}

class MultiSelectItem {
  final int id;
  final String name;

  MultiSelectItem({required this.id, required this.name});

  factory MultiSelectItem.fromJson(Map<String, dynamic> json) {
    return MultiSelectItem(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

Future<MultiSelectResult> getItems<T extends Model>(
    String url, T Function(Map<String, dynamic>) fromJson) async {
  List<T> data;

  List<Map<String, dynamic>> items;
  List<MultiSelectItem> multiSelectItems;
  data = await ApiService.fetchList<T>(url, fromJson);
  if (data.isNotEmpty) {
    items = data.map((item) => item.toJson()).toList();

    multiSelectItems =
        items.map((item) => MultiSelectItem.fromJson(item)).toList();
    return MultiSelectResult.onSuccess(items: multiSelectItems);
  } else {
    return MultiSelectResult.onError(errorMessage: 'Failed to fetch items');
  }
}

class MultiSelectController extends GetxController {
  var pickedItems = <MultiSelectItem>[].obs;

  void addItem(MultiSelectItem item) {
    if (!pickedItems.any((e) => e.id == item.id)) {
      pickedItems.add(item);
    }
  }

  void removeItem(MultiSelectItem item) {
    pickedItems.removeWhere((e) => e.id == item.id);
  }

  void clearItems() {
    pickedItems.clear();
  }

  void setAllItems(List<MultiSelectItem> all) {
    pickedItems.assignAll(all);
  }
}

class MultiSelect extends StatefulWidget {
  final List<MultiSelectItem> preparedData;
  final Function(List<MultiSelectItem>) getPickedItems;
  final String hintText;
  final int? maxSelectedItems;
  final List<MultiSelectItem>? initialPickedItems;

  const MultiSelect({
    super.key,
    required this.getPickedItems,
    required this.preparedData,
    required this.hintText,
    required this.maxSelectedItems,
    this.initialPickedItems,
  });

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  late final MultipleSearchController _multipleSearchController;
  final MultiSelectController multiSelectController =
      Get.put(MultiSelectController());

  @override
  void initState() {
    super.initState();

    _multipleSearchController = MultipleSearchController(
      allowDuplicateSelection: false,
      isSelectable: false,
      minCharsToShowItems: 1,
    );

    dev.log('MultiSelect initialized with ${widget.preparedData.length} items');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        MultipleSearchSelection<MultiSelectItem>.overlay(
          controller: _multipleSearchController,
          maxSelectedItems: widget.maxSelectedItems,
          clearSearchFieldOnSelect: true,
          initialPickedItems: widget.initialPickedItems != null
              ? widget.preparedData
                  .where((item) => widget.initialPickedItems!
                      .map((e) => e.id)
                      .contains(item.id))
                  .toList()
              : [],
          searchField: TextField(
            decoration: InputDecoration(
              hintText: widget.hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          items: widget.preparedData,
          fieldToCheck: (item) => item.name,
          sortPickedItems: true,
          sortShowedItems: true,

          // 🔥 GetX integration here
          onItemAdded: (item) {
            multiSelectController.addItem(item);
            widget.getPickedItems(multiSelectController.pickedItems);
            dev.log('Added: ${item.name}');
          },
          onItemRemoved: (item) {
            multiSelectController.removeItem(item);
            widget.getPickedItems(multiSelectController.pickedItems);
            dev.log('Removed: ${item.name}');
          },
          onTapClearAll: () {
            _multipleSearchController.clearAllPickedItemsCallback?.call();
            _multipleSearchController.clearSearchField();
            multiSelectController.clearItems();
            widget.getPickedItems([]);
          },
          onTapSelectAll: () {
            _multipleSearchController.selectAllItems();
            multiSelectController.setAllItems(widget.preparedData);
            widget.getPickedItems(widget.preparedData);
          },

          itemBuilder: (item, index, isPicked) => Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isPicked
                    ? colorScheme.primaryContainer
                    : colorScheme.surface,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Text(item.name, style: textTheme.bodySmall),
              ),
            ),
          ),

          pickedItemBuilder: (item) => Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.name, style: textTheme.bodySmall),
                  const SizedBox(width: 4),
                  Icon(Icons.close, size: 16, color: colorScheme.onSurface),
                ],
              ),
            ),
          ),

          clearAllButton: Text(
            'Clear All',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
          ),
          selectAllButton: Text(
            'Select All',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
          ),
          noResultsWidget: ListTile(
            title: Text(
              'No results found',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          maximumShowItemsHeight: 200,
        ),
      ],
    );
  }
}
