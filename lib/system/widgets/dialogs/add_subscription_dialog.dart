import 'package:flutter/material.dart';

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
    'الاشتراك الشهري': 0, // handled by month selection (the only one actually explained in the video)
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