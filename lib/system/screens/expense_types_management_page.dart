import 'package:flutter/material.dart';
import 'base_layout.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class ExpenseTypesManagementPage extends StatefulWidget {
  const ExpenseTypesManagementPage({Key? key}) : super(key: key);

  static const Color tealColor = Color(0xFF19A598);
  static const Color goldColor = Color(0xFFBE9656);

  static const List<String> expenseTypes = [
    'جوائز',
    'رواتب',
    'نوع تجريبي',
  ];

  @override
  State<ExpenseTypesManagementPage> createState() =>
      _ExpenseTypesManagementPageState();
}

class _ExpenseTypesManagementPageState
    extends State<ExpenseTypesManagementPage> {
  int _rowsPerPage = 15;
  int _page = 0;
  String _search = '';
  final TextEditingController _searchController = TextEditingController();

  List<List<String>> allRows = [];
  List<bool> selectedRows = [];

  List<List<String>> get filteredRows {
    if (_search.isEmpty) return allRows;
    return allRows
        .where((row) => row.any((cell) => cell.contains(_search)))
        .toList();
  }

  void _showAddDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => AddExpenseTypeDialog(),
    );
    if (result != null && result.length == 2) {
      setState(() {
        allRows.add(result);
        selectedRows.add(false);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة السطر!')),
      );
    }
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];
    sheet.appendRow(['نوع المصروف', 'ملاحظة']);
    for (final row in filteredRows) {
      sheet.appendRow([row[0], row[1]]);
    }
    final excelBytes = excel.encode();
    if (excelBytes != null) {
      if (kIsWeb) {
        final blob = html.Blob([
          excelBytes
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'export_expenses.xlsx')
          ..click();
        html.Url.revokeObjectUrl(url);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تصدير البيانات إلى Excel!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Excel export فقط متاح على الويب حالياً')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    allRows = [
      ['جوائز', ''],
      ['رواتب', ''],
      ['نوع تجريبي', 'ملاحظة تجريبية'],
    ];
    selectedRows = List.generate(allRows.length, (_) => false);
  }

  void _onRowCheck(int dataIndex, bool? value) {
    setState(() {
      selectedRows[dataIndex] = value ?? false;
    });
  }

  int _getRowDataIndex(List<String> row) {
    return allRows.indexOf(row);
  }

  void _showEditDialog(int rowIndex) async {
    final oldRow = allRows[rowIndex];
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => EditExpenseTypeDialog(
        initialData: oldRow,
      ),
    );
    if (result != null && result.length == 2) {
      setState(() {
        allRows[rowIndex] = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تعديل السطر!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagedRows =
        filteredRows.skip(_page * _rowsPerPage).take(_rowsPerPage).toList();
    final from = filteredRows.isEmpty ? 0 : _page * _rowsPerPage + 1;
    final to = (_page * _rowsPerPage + pagedRows.length);
    final total = filteredRows.length;
    final lastPage = (total / _rowsPerPage).ceil() - 1;
    final pagedRowsIndexes =
        pagedRows.map((row) => _getRowDataIndex(row)).toList();

    final selectedGlobal = List.generate(allRows.length, (i) => i)
        .where((i) => selectedRows[i])
        .toList();

    final onlyOneSelected = selectedGlobal.length == 1;
    final anySelected = selectedGlobal.isNotEmpty;
    final selectedRowIndex = onlyOneSelected ? selectedGlobal.first : null;

    return BaseLayout(
      title: 'إدارة أنواع المصاريف',
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Breadcrumb
            Container(
              height: 38,
              decoration: BoxDecoration(
                color: ExpenseTypesManagementPage.goldColor,
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: const Text(
                'الصفحة الرئيسية / الشؤون المالية / إعدادات المالية / إدارة أنواع المصاريف',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons Row (Left side)
            Row(
              children: [
                _TopButton(
                  text: "Excel",
                  color: ExpenseTypesManagementPage.tealColor,
                  onPressed: _exportToExcel,
                ),
                const SizedBox(width: 10),
                _ShowDropdown(
                  value: _rowsPerPage,
                  onChanged: (value) {
                    setState(() {
                      _rowsPerPage = value;
                      _page = 0;
                    });
                  },
                ),
                const SizedBox(width: 10),
                _TopButton(
                  text: "إظهار 15 سطر",
                  color: ExpenseTypesManagementPage.tealColor,
                  onPressed: () {
                    setState(() {
                      _rowsPerPage = 15;
                      _page = 0;
                    });
                  },
                ),
                const Spacer(),
                _TopButton(
                  text: 'إضافة',
                  color: ExpenseTypesManagementPage.goldColor,
                  textColor: Colors.white,
                  onPressed: _showAddDialog,
                ),
                const SizedBox(width: 10),
                _TopButton(
                  text: 'تعديل',
                  color: Color(0xFFECECEC),
                  textColor: onlyOneSelected ? Colors.teal : Color(0xFFBDBDBD),
                  enabled: onlyOneSelected,
                  onPressed: onlyOneSelected && selectedRowIndex != null
                      ? () => _showEditDialog(selectedRowIndex)
                      : null,
                ),
                const SizedBox(width: 10),
                _TopButton(
                  text: 'تكرار',
                  color: Color(0xFFECECEC),
                  textColor: anySelected ? Colors.teal : Color(0xFFBDBDBD),
                  enabled: anySelected,
                  onPressed: anySelected
                      ? () {
                          setState(() {
                            for (final idx in selectedGlobal) {
                              allRows.add(List<String>.from(allRows[idx]));
                              selectedRows.add(false);
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('تم تكرار الصفوف المحددة!')),
                          );
                        }
                      : null,
                ),
                const SizedBox(width: 10),
                _TopButton(
                  text: 'حذف',
                  color: Color(0xFFECECEC),
                  textColor: anySelected ? Colors.red : Color(0xFFBDBDBD),
                  enabled: anySelected,
                  onPressed: anySelected
                      ? () {
                          setState(() {
                            final toDelete = selectedGlobal.toList()
                              ..sort((a, b) => b.compareTo(a));
                            for (final idx in toDelete) {
                              allRows.removeAt(idx);
                              selectedRows.removeAt(idx);
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('تم حذف الصفوف المحددة!')),
                          );
                        }
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search bar line (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _searchController,
                    textAlign: TextAlign.right,
                    onChanged: (value) {
                      setState(() {
                        _search = value;
                        _page = 0;
                      });
                    },
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: ExpenseTypesManagementPage.tealColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  ' : ابحث',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Table 
            Expanded(
              child: Container(
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, tableConstraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: tableConstraints.maxHeight),
                        child: DataTable(
                          border: TableBorder.all(
                            color: Colors.grey.shade400,
                            width: 1.0,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          headingRowColor: MaterialStateProperty.all(
                              ExpenseTypesManagementPage.tealColor),
                          dataRowColor: MaterialStateProperty.all(Colors.white),
                          columnSpacing: 24,
                          dataRowMinHeight: 45,
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          dataTextStyle: const TextStyle(fontSize: 16),
                          columns: const [
                            DataColumn(label: Text('نوع المصروف')),
                            DataColumn(label: Text('ملاحظة')),
                            DataColumn(
                                label: SizedBox(
                                    width:
                                        36)), // ONLY ONE checkbox column (right)
                          ],
                          rows: List<DataRow>.generate(
                            pagedRows.length,
                            (i) {
                              final dataIndex = pagedRowsIndexes[i];
                              return DataRow(
                                selected: selectedRows[dataIndex],
                                cells: [
                                  DataCell(Text(pagedRows[i][0])),
                                  DataCell(Text(pagedRows[i][1])),
                                  DataCell(
                                    Checkbox(
                                      value: selectedRows[dataIndex],
                                      onChanged: (val) =>
                                          _onRowCheck(dataIndex, val),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Footer pagination
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  _FooterNavButton(
                    text: 'التالي',
                    enabled: _page < lastPage,
                    onPressed:
                        _page < lastPage ? () => setState(() => _page++) : null,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: ExpenseTypesManagementPage.goldColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Text(
                      (_page + 1).toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 6),
                  _FooterNavButton(
                    text: 'السابق',
                    enabled: _page > 0,
                    onPressed: _page > 0 ? () => setState(() => _page--) : null,
                  ),
                  const Spacer(),
                  Text(
                    'إظهار $from إلى $to من أصل $total مخزن $total قيمة محددة 0 أعمدة محددة 0 خلايا محددة',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- BUTTONS AND WIDGETS ---

class _TopButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onPressed;
  final bool enabled;
  const _TopButton({
    required this.text,
    this.color,
    this.textColor,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Colors.white;
    final fgColor = textColor ??
        (color == ExpenseTypesManagementPage.tealColor
            ? Colors.white
            : (color == ExpenseTypesManagementPage.goldColor
                ? Colors.white
                : ExpenseTypesManagementPage.tealColor));
    return SizedBox(
      width: 110,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: fgColor,
          padding: EdgeInsets.zero,
          elevation: 0,
          minimumSize: const Size(110, 45),
          maximumSize: const Size(110, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: buttonColor == Colors.white
                ? const BorderSide(
                    color: ExpenseTypesManagementPage.tealColor, width: 1.6)
                : BorderSide.none,
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: enabled ? onPressed : null,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterNavButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final VoidCallback? onPressed;
  const _FooterNavButton(
      {required this.text, this.enabled = true, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled && onPressed != null ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
        foregroundColor: Colors.black,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        elevation: 0,
        minimumSize: const Size(70, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      child: Text(text),
    );
  }
}

/// Shows the dropdown for selecting rows per page
class _ShowDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _ShowDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 45,
      child: DropdownButtonHideUnderline(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: ExpenseTypesManagementPage.tealColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<int>(
            value: value,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            dropdownColor: ExpenseTypesManagementPage.tealColor,
            borderRadius: BorderRadius.circular(6),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
            selectedItemBuilder: (context) => List.generate(
                5,
                (_) => const Center(
                    child: Text("إظهار",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)))),
            items: const [
              DropdownMenuItem(
                  value: 5,
                  child: Text("إظهار 5 سطر",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              DropdownMenuItem(
                  value: 10,
                  child: Text("إظهار 10 سطر",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              DropdownMenuItem(
                  value: 15,
                  child: Text("إظهار 15 سطر",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              DropdownMenuItem(
                  value: 20,
                  child: Text("إظهار 20 سطر",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
              DropdownMenuItem(
                  value: 30,
                  child: Text("إظهار 30 سطر",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))),
            ],
          ),
        ),
      ),
    );
  }
}

// ----- EDIT DIALOG -----

class EditExpenseTypeDialog extends StatefulWidget {
  final List<String> initialData;
  const EditExpenseTypeDialog({Key? key, required this.initialData})
      : super(key: key);

  @override
  State<EditExpenseTypeDialog> createState() => _EditExpenseTypeDialogState();
}

class _EditExpenseTypeDialogState extends State<EditExpenseTypeDialog> {
  late TextEditingController typeController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    typeController = TextEditingController(text: widget.initialData[0]);
    noteController = TextEditingController(text: widget.initialData[1]);
  }

  @override
  void dispose() {
    typeController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 60),
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: const BoxDecoration(
                color: ExpenseTypesManagementPage.tealColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: const Center(
                child: Text(
                  'تعديل السطر',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('نوع المصروف', textAlign: TextAlign.right),
                  const SizedBox(height: 6),
                  TextField(
                    controller: typeController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('ملاحظة', textAlign: TextAlign.right),
                  const SizedBox(height: 6),
                  TextField(
                    controller: noteController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ExpenseTypesManagementPage.tealColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  
                  Navigator.of(context)
                      .pop([typeController.text, noteController.text]);
                },
                child: const Text('حفظ التعديلات',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----- ADD DIALOG (POPUP WINDOW) -----

class AddExpenseTypeDialog extends StatefulWidget {
  const AddExpenseTypeDialog({Key? key}) : super(key: key);

  @override
  State<AddExpenseTypeDialog> createState() => _AddExpenseTypeDialogState();
}

class _AddExpenseTypeDialogState extends State<AddExpenseTypeDialog> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Add dummy controllers for the foreign language fields (not used cuz i do not know where they should go )
  final TextEditingController typeForeignController = TextEditingController();
  final TextEditingController noteForeignController = TextEditingController();

  @override
  void dispose() {
    typeController.dispose();
    noteController.dispose();
    typeForeignController.dispose();
    noteForeignController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 60),
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with pattern and title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: const BoxDecoration(
                color: ExpenseTypesManagementPage.tealColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                image: DecorationImage(
                  image: AssetImage('assets/pattern.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'إضافة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
            // Form fields 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(' : نوع المصروف',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: typeController,
                    decoration: InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(' : نوع المصروف بالأجنبي',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: typeForeignController,
                    decoration: InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(' : ملاحظة',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(' : الملاحظة بالأجنبي',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: noteForeignController,
                    decoration: InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ExpenseTypesManagementPage.tealColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  
                  Navigator.of(context)
                      .pop([typeController.text, noteController.text]);
                },
                child: const Text('إضافة',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
