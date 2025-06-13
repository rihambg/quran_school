import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/utils/snackbar_helper.dart';

class GenericDataSource<T> extends DataGridSource {
  final List<T> data;
  final Map<DataGridRow, T> _rowToModelMap = {};
  final DataGridController gridController;
  final Future<void> Function(int id)? onDelete;
  final Future<void> Function() onRefresh;
  final DataGridRow Function(T model) rowBuilder;
  final dynamic Function(DataGridRow row) idExtractor;
  final String detailsTitle;
  final Widget? Function(DataGridCell cell)? cellBuilder;
  final IconData infoIcon;
  final IconData deleteIcon;
  final Color? selectionColor;

  GenericDataSource({
    required this.data,
    required this.gridController,
    required this.onDelete,
    required this.onRefresh,
    required this.rowBuilder,
    required this.idExtractor,
    this.detailsTitle = 'تفاصيل العنصر',
    this.cellBuilder,
    this.infoIcon = Icons.info_outline,
    this.deleteIcon = Icons.delete,
    this.selectionColor,
  }) {
    _data = data;
    buildDataGridRows();
  }

  List<T> _data = [];
  late List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  /// Refresh the data source with new data
  void updateDataSource(List<T> newData) {
    _data = newData;
    buildDataGridRows();
    notifyListeners();
  }

  /// Build rows from the given model list
  void buildDataGridRows() {
    _rowToModelMap.clear();
    _rows = _data.map<DataGridRow>((e) {
      final row = rowBuilder(e);
      _rowToModelMap[row] = e;
      return row;
    }).toList();
  }

  /// Get model object from a specific row
  T? getModelFromRow(DataGridRow row) => _rowToModelMap[row];

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final isSelected = gridController.selectedRows.contains(row);
    final cells = row.getCells();

    return DataGridRowAdapter(
      color:
          isSelected ? (selectionColor ?? Colors.blue.withOpacity(0.1)) : null,
      cells: cells.map<Widget>((cell) {
        if (cell.columnName == 'button') {
          return _buildActionCell(row);
        } else {
          return _buildDataCell(cell);
        }
      }).toList(),
    );
  }

  /// Cell with action icon (info)
  Widget _buildActionCell(DataGridRow row) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        child: Icon(infoIcon, color: Colors.blue),
        onTap: () => _showRowDetails(row),
      ),
    );
  }

  /// Normal data cell
  Widget _buildDataCell(DataGridCell cell) {
    return cellBuilder?.call(cell) ??
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value?.toString() ?? '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        );
  }

  /// Confirm and delete row item
  void _showDeleteDialog(DataGridRow row) async {
    final result = await Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا العنصر؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        final id = idExtractor(row);
        await onDelete?.call(id);
        await onRefresh();
        showSuccessSnackbar(Get.context!, 'تم حذف العنصر بنجاح');
      } catch (e) {
        dev.log("Delete error: $e");
        showErrorSnackbar(Get.context!, 'فشل في حذف العنصر');
      }
    }
  }

  /// Show full row details in dialog
  void _showRowDetails(DataGridRow row) {
    final details = row
        .getCells()
        .where((c) => c.columnName != 'button')
        .map(
          (cell) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    '${cell.columnName}:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    cell.value?.toString() ?? '',
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    Get.dialog(
      AlertDialog(
        title: Text(detailsTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: details,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
