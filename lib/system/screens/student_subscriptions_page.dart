import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class StudentSubscriptionsPage extends StatefulWidget {
  const StudentSubscriptionsPage({Key? key}) : super(key: key);

  static const Color tealColor = Color(0xFF19A598);
  static const Color goldColor = Color(0xFFBE9656);

  @override
  State<StudentSubscriptionsPage> createState() =>
      _StudentSubscriptionsPageState();
}

class _StudentSubscriptionsPageState extends State<StudentSubscriptionsPage> {
  int _rowsPerPage = 15;
  int _page = 0;
  String _search = '';
  final TextEditingController _searchController = TextEditingController();

  // Filters
  String _selectedType = 'جميع الأنواع';
  final List<String> _subscriptionTypes = [
    'جميع الأنواع',
    'الاشتراك السنوي',
    'الاشتراك الشهري',
    'الاشتراك الفصلي',
  ];
  DateTime? _fromDate = DateTime(2022, 1, 1);
  DateTime? _toDate = DateTime(2023, 12, 31);

  // Table Data
  List<List<String>> allRows = [];
  List<bool> selectedRows = [];

  List<List<String>> get filteredRows {
    List<List<String>> rows = List.from(allRows);
    // Filter by type
    if (_selectedType != 'جميع الأنواع') {
      rows = rows.where((row) => row[5].contains(_selectedType)).toList();
    }
    // Filter by date
    if (_fromDate != null) {
      rows = rows
          .where((row) =>
              DateTime.tryParse(row[4]) != null &&
              DateTime.parse(row[4])
                  .isAfter(_fromDate!.subtract(const Duration(days: 1))))
          .toList();
    }
    if (_toDate != null) {
      rows = rows
          .where((row) =>
              DateTime.tryParse(row[4]) != null &&
              DateTime.parse(row[4])
                  .isBefore(_toDate!.add(const Duration(days: 1))))
          .toList();
    }
    // Filter by search
    if (_search.isNotEmpty) {
      rows = rows
          .where((row) => row.any(
              (cell) => cell.toLowerCase().contains(_search.toLowerCase())))
          .toList();
    }
    return rows;
  }

  @override
  void initState() {
    super.initState();
    allRows = [
      // [رقم السند, الطالب, الحالة, المبلغ, تاريخ الدفع, النوع]
      [
        "INV100059",
        "عبد الرحمن كرامة",
        "تم الدفع",
        "5000.00",
        "2022-03-25",
        "الاشتراك السنوي"
      ],
      [
        "INV100058",
        "محمد امين 2",
        "تم الدفع",
        "7500.00",
        "2022-04-01",
        "الاشتراك الشهري"
      ],
      [
        "INV100057",
        "عبد الرحمن بن بثقة",
        "تم الدفع",
        "10000.00",
        "2022-05-10",
        "الاشتراك الشهري"
      ],
      [
        "INV100056",
        "محمد بن طالب",
        "تم الدفع",
        "500.00",
        "2022-06-01",
        "الاشتراك الفصلي"
      ],
      [
        "INV100060",
        "سلمان الماجد",
        "لم يتم الدفع",
        "2000.00",
        "2022-04-10",
        "الاشتراك السنوي"
      ],
      [
        "INV100061",
        "أحمد الجبيري",
        "لم يتم الدفع",
        "1500.00",
        "2022-07-15",
        "الاشتراك الشهري"
      ],
      [
        "INV100062",
        "يوسف كمال",
        "دفع جزئي",
        "3000.00 / 5000.00",
        "2022-09-20",
        "الاشتراك الفصلي"
      ],
      [
        "INV100063",
        "حسن فهد",
        "تم الدفع",
        "8000.00",
        "2022-10-01",
        "الاشتراك السنوي"
      ],
      [
        "INV100064",
        "محمود درويش",
        "دفع جزئي",
        "1000.00 / 2500.00",
        "2022-10-30",
        "الاشتراك الشهري"
      ],
      [
        "INV100065",
        "عبدالله صالح",
        "لم يتم الدفع",
        "3000.00",
        "2022-11-15",
        "الاشتراك السنوي"
      ],
      [
        "INV100066",
        "عبدالإله العتيبي",
        "تم الدفع",
        "4000.00",
        "2023-01-16",
        "الاشتراك الشهري"
      ],
      [
        "INV100067",
        "أيمن حسن",
        "تم الدفع",
        "6000.00",
        "2023-02-18",
        "الاشتراك الفصلي"
      ],
      [
        "INV100068",
        "بدر محمد",
        "لم يتم الدفع",
        "5500.00",
        "2023-03-01",
        "الاشتراك السنوي"
      ],
      [
        "INV100069",
        "جمال عمر",
        "دفع جزئي",
        "600.00 / 1200.00",
        "2023-03-10",
        "الاشتراك الشهري"
      ],
      [
        "INV100070",
        "طارق ياسر",
        "تم الدفع",
        "8700.00",
        "2023-04-14",
        "الاشتراك السنوي"
      ],
      [
        "INV100071",
        "حاتم يوسف",
        "تم الدفع",
        "4700.00",
        "2023-05-20",
        "الاشتراك الفصلي"
      ],
      [
        "INV100072",
        "مالك عادل",
        "لم يتم الدفع",
        "6200.00",
        "2023-06-03",
        "الاشتراك الشهري"
      ],
      [
        "INV100073",
        "سامي أنور",
        "دفع جزئي",
        "3000.00 / 5400.00",
        "2023-07-04",
        "الاشتراك السنوي"
      ],
      [
        "INV100074",
        "سعيد خالد",
        "تم الدفع",
        "3300.00",
        "2023-08-06",
        "الاشتراك الشهري"
      ],
      [
        "INV100075",
        "مازن نور",
        "لم يتم الدفع",
        "1200.00",
        "2023-09-10",
        "الاشتراك الفصلي"
      ],
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

  void _showAddDialog() async {
    showDialog(
      context: context,
      builder: (context) => AddSubscriptionDialog(
        onSubmit: (name, type, months, amountDue, amountPaid, paymentDate) {
          setState(() {
            String typeDisplay = type;
            if (type == 'الاشتراك الشهري' && months.isNotEmpty) {
              typeDisplay += ' (${months.join(", ")})';
            }
            allRows.insert(
              0,
              [
                'INV${100000 + allRows.length + 1}',
                name,
                amountPaid >= amountDue
                    ? 'تم الدفع'
                    : (amountPaid > 0 ? 'دفع جزئي' : 'لم يتم الدفع'),
                amountPaid >= amountDue
                    ? amountDue.toStringAsFixed(2)
                    : (amountPaid > 0
                        ? '${amountPaid.toStringAsFixed(2)} / ${amountDue.toStringAsFixed(2)}'
                        : amountDue.toStringAsFixed(2)),
                "${paymentDate.year.toString().padLeft(4, '0')}-${paymentDate.month.toString().padLeft(2, '0')}-${paymentDate.day.toString().padLeft(2, '0')}",
                typeDisplay,
              ],
            );
            selectedRows.insert(0, false);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة الاشتراك!')),
          );
        },
      ),
    );
  }

  void _showEditDialog(int rowIndex) async {
    
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];
    sheet.appendRow([
      'رقم السند',
      'الطالب',
      'الحالة',
      'المبلغ',
      'تاريخ الدفع',
      'النوع',
    ]);
    for (final row in filteredRows) {
      sheet.appendRow([
        row[0],
        row[1],
        row[2],
        row[3],
        row[4],
        row[5],
      ]);
    }
    final excelBytes = excel.encode();
    if (excelBytes != null) {
      if (kIsWeb) {
        final blob = html.Blob([
          excelBytes
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'student_subscriptions.xlsx')
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

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    DateTime initialDate =
        isFrom ? (_fromDate ?? DateTime.now()) : (_toDate ?? DateTime.now());
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      textDirection: TextDirection.rtl,
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
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

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            width: double.infinity,
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
                    color: StudentSubscriptionsPage.goldColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: const Text(
                    'الصفحة الرئيسية / الشؤون المالية / إدارة الاشتراكات / اشتراكات الطلاب',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Filters row
                Row(
                  children: [
                    // نوع الاشتراك
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        items: _subscriptionTypes
                            .map(
                              (type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'نوع الاشتراك *',
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: StudentSubscriptionsPage.goldColor,
                                width: 1.2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // من
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: _fromDate != null
                              ? "${_fromDate!.year.toString().padLeft(4, '0')}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}"
                              : "",
                        ),
                        decoration: InputDecoration(
                          labelText: 'من',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                  color: StudentSubscriptionsPage.goldColor,
                                  width: 1.2)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                        textAlign: TextAlign.right,
                        onTap: () => _pickDate(context, true),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // إلى
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: _toDate != null
                              ? "${_toDate!.year.toString().padLeft(4, '0')}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}"
                              : "",
                        ),
                        decoration: InputDecoration(
                          labelText: 'إلى',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                  color: StudentSubscriptionsPage.goldColor,
                                  width: 1.2)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                        textAlign: TextAlign.right,
                        onTap: () => _pickDate(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Buttons Row
                Row(
                  children: [
                    _TopButton(
                      text: "Excel",
                      color: StudentSubscriptionsPage.tealColor,
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
                      color: StudentSubscriptionsPage.tealColor,
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
                      color: StudentSubscriptionsPage.goldColor,
                      textColor: Colors.white,
                      onPressed: _showAddDialog,
                    ),
                    const SizedBox(width: 10),
                    _TopButton(
                      text: 'تعديل',
                      color: Color(0xFFECECEC),
                      textColor:
                          onlyOneSelected ? Colors.teal : Color(0xFFBDBDBD),
                      enabled: onlyOneSelected,
                      onPressed: onlyOneSelected && selectedRowIndex != null
                          ? () => _showEditDialog(selectedRowIndex)
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

                // Search bar line (align right)
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
                              color: StudentSubscriptionsPage.tealColor,
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
                                  StudentSubscriptionsPage.tealColor),
                              dataRowColor:
                                  MaterialStateProperty.all(Colors.white),
                              columnSpacing: 18,
                              dataRowMinHeight: 45,
                              headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              dataTextStyle: const TextStyle(fontSize: 16),
                              columns: const [
                                DataColumn(label: Text('طباعة')),
                                DataColumn(label: Text('النوع')),
                                DataColumn(label: Text('تاريخ الدفع')),
                                DataColumn(label: Text('المبلغ')),
                                DataColumn(label: Text('الحالة')),
                                DataColumn(label: Text('الطالب')),
                                DataColumn(label: Text('رقم السند')),
                                DataColumn(label: SizedBox(width: 36)),
                              ],
                              rows: List<DataRow>.generate(
                                pagedRows.length,
                                (i) {
                                  final dataIndex = pagedRowsIndexes[i];
                                  final row = pagedRows[i];
                                  return DataRow(
                                    selected: selectedRows[dataIndex],
                                    cells: [
                                      DataCell(Row(
                                        children: [
                                          _PrintButton(
                                            label: 'A5 طباعة',
                                            color: StudentSubscriptionsPage
                                                .goldColor,
                                            onPressed: () {},
                                          ),
                                          const SizedBox(width: 6),
                                          _PrintButton(
                                            label: 'A4 طباعة',
                                            color: StudentSubscriptionsPage
                                                .goldColor,
                                            onPressed: () {},
                                          ),
                                        ],
                                      )),
                                      DataCell(Text(row[5])),
                                      DataCell(Text(row[4])),
                                      DataCell(Text(row[3])),
                                      DataCell(_StatusLabel(
                                        label: row[2],
                                        checked: row[2] == 'تم الدفع',
                                        partial: row[2] == 'دفع جزئي',
                                        notPaid: row[2] == 'لم يتم الدفع',
                                      )),
                                      DataCell(Text(row[1])),
                                      DataCell(Text(row[0])),
                                      DataCell(
                                        Checkbox(
                                          value: selectedRows[dataIndex],
                                          onChanged: (val) =>
                                              _onRowCheck(dataIndex, val),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                        onPressed: _page < lastPage
                            ? () => setState(() => _page++)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: StudentSubscriptionsPage.goldColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        child: Text(
                          (_page + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _FooterNavButton(
                        text: 'السابق',
                        enabled: _page > 0,
                        onPressed:
                            _page > 0 ? () => setState(() => _page--) : null,
                      ),
                      const Spacer(),
                      Text(
                        'إظهار $from إلى $to من أصل $total مخزن $total قيمة محددة 0 أعمدة محددة 0 خلايا محددة',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- ADD SUBSCRIPTION DIALOG ---

class AddSubscriptionDialog extends StatefulWidget {
  final void Function(
    String name,
    String type,
    List<String> months,
    double amountDue,
    double amountPaid,
    DateTime paymentDate,
  )? onSubmit;

  const AddSubscriptionDialog({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<AddSubscriptionDialog> createState() => _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState extends State<AddSubscriptionDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountDueController = TextEditingController();
  final TextEditingController _amountPaidController = TextEditingController();

  String? _selectedType;
  DateTime? _paymentDate = DateTime.now();
  List<String> _selectedMonths = [];
  double _autoAmountDue = 0;

  final Map<String, double> monthlyAmounts = {
    'يناير': 1000,
    'فبراير': 1000,
    'مارس': 1000,
    'ابريل': 1000,
    'مايو': 1000,
    'يونيو': 1000,
    'يوليو': 1000,
    'اغسطس': 1000,
    'سبتمبر': 1000,
    'اكتوبر': 1000,
    'نوفمبر': 1000,
    'ديسمبر': 1000,
  };

  final Map<String, double> typeAmounts = {
    'اشتراك الرحلات': 2000,
    'الاشتراك السنوي': 10000,
    'الاشتراك الشهري': 0, // handled by month selection cause it was the only one explained in the video 
    'الاشتراك الفصلي': 3000,
    'تجريبي': 0,
  };

  final List<String> subscriptionTypes = [
    'اشتراك الرحلات',
    'الاشتراك السنوي',
    'الاشتراك الشهري',
    'الاشتراك الفصلي',
    'تجريبي',
  ];

  void _onTypeChanged(String? value) {
    setState(() {
      _selectedType = value;
      _selectedMonths.clear();
      if (_selectedType == 'الاشتراك الشهري') {
        _autoAmountDue = 0;
        _amountDueController.text = '0';
      } else if (_selectedType != null &&
          typeAmounts.containsKey(_selectedType!)) {
        _autoAmountDue = typeAmounts[_selectedType!]!;
        _amountDueController.text = _autoAmountDue.toStringAsFixed(2);
      } else {
        _autoAmountDue = 0;
        _amountDueController.text = '';
      }
    });
  }

  void _onMonthToggle(String month) {
    setState(() {
      if (_selectedMonths.contains(month)) {
        _selectedMonths.remove(month);
      } else {
        _selectedMonths.add(month);
      }
      _autoAmountDue = _selectedMonths.fold(
        0,
        (sum, m) => sum + (monthlyAmounts[m] ?? 0),
      );
      _amountDueController.text = _autoAmountDue.toStringAsFixed(2);
    });
  }

  void _onAmountDueChanged(String value) {
    setState(() {
      double? parsed = double.tryParse(value.replaceAll(',', ''));
      if (parsed != null) {
        _autoAmountDue = parsed;
      }
    });
  }

  void _onPickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      textDirection: TextDirection.rtl,
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _paymentDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Container(
          width: 540,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF19A598),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'إضافة اشتراك',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Name
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'الاسم الكامل :',
                  style: TextStyle(
                      color: Colors.grey[800], fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(height: 14),
              // Type
              DropdownButtonFormField<String>(
                value: _selectedType,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: "النوع",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: subscriptionTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type, textAlign: TextAlign.right),
                        ))
                    .toList(),
                onChanged: _onTypeChanged,
                hint: const Text("اختر النوع"),
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.arrow_drop_down),
              ),
              // Months selection (if monthly)
              if (_selectedType == 'الاشتراك الشهري') ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'حدد الأشهر:',
                    style: TextStyle(
                        color: Colors.teal[700], fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: monthlyAmounts.keys
                      .map(
                        (month) => ChoiceChip(
                          label: Text(month),
                          selected: _selectedMonths.contains(month),
                          onSelected: (_) => _onMonthToggle(month),
                          selectedColor: const Color(0xFF19A598),
                          labelStyle: TextStyle(
                              color: _selectedMonths.contains(month)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 18),
              // Amount fields, payment date
              Row(
                children: [
                  // Paid Amount
                  Expanded(
                    child: TextFormField(
                      controller: _amountPaidController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: 'المبلغ المدفوع',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Amount Due
                  Expanded(
                    child: TextFormField(
                      controller: _amountDueController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      onChanged: _onAmountDueChanged,
                      decoration: InputDecoration(
                        labelText: 'المبلغ المستحق',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Payment Date
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      textAlign: TextAlign.right,
                      controller: TextEditingController(
                        text: _paymentDate == null
                            ? ''
                            : "${_paymentDate!.year.toString().padLeft(4, '0')}-${_paymentDate!.month.toString().padLeft(2, '0')}-${_paymentDate!.day.toString().padLeft(2, '0')}",
                      ),
                      onTap: _onPickDate,
                      decoration: InputDecoration(
                        labelText: 'تاريخ الدفع',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              // Add Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF19A598),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                onPressed: () {
                  if (widget.onSubmit != null) {
                    widget.onSubmit!(
                      _nameController.text,
                      _selectedType ?? '',
                      List<String>.from(_selectedMonths),
                      double.tryParse(_amountDueController.text) ?? 0,
                      double.tryParse(_amountPaidController.text) ?? 0,
                      _paymentDate ?? DateTime.now(),
                    );
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('إضافة'),
              ),
            ],
          ),
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
        (color == StudentSubscriptionsPage.tealColor
            ? Colors.white
            : (color == StudentSubscriptionsPage.goldColor
                ? Colors.white
                : StudentSubscriptionsPage.tealColor));
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
                    color: StudentSubscriptionsPage.tealColor, width: 1.6)
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
            color: StudentSubscriptionsPage.tealColor,
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
            dropdownColor: StudentSubscriptionsPage.tealColor,
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

class _PrintButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const _PrintButton(
      {required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.print, size: 17),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final String label;
  final bool checked;
  final bool partial;
  final bool notPaid;
  const _StatusLabel({
    required this.label,
    this.checked = false,
    this.partial = false,
    this.notPaid = false,
  });
  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData icon;
    if (checked) {
      bgColor = StudentSubscriptionsPage.tealColor;
      icon = Icons.check_box;
    } else if (partial) {
      bgColor = Colors.orange[700]!;
      icon = Icons.indeterminate_check_box;
    } else {
      bgColor = Colors.red[400]!;
      icon = Icons.close;
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
