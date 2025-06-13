import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../../system/models/report3_model.dart';
import '../helpers/accompanying_curriculum_section.dart';
import '../helpers/tjweed_section.dart';
import '../helpers/info_section.dart';
import '../../system/models/shared.dart';
import '../helpers/table_helpers.dart';

List<pw.Widget> buildReport3Content({
  required dynamic reportDataModel,
  required pw.Font baseFont,
  required pw.Font boldFont,
  required pw.Font fallbackFont,
}) {
  final fullReport = reportDataModel as FullReport<OverallSummary3>;

  return [
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          TableHelpers.buildTopHeaderSection(fullReport.reportTitle, boldFont),
          pw.SizedBox(height: 10),
          buildInfoTableSection(
            HeaderInfo(
              schoolName: fullReport.reportDetails.schoolName,
              teacherName: fullReport.reportDetails.teacherName,
              lectureName: fullReport.reportDetails.courseName,
              reportPeriodHijri: fullReport.reportDetails.periodHijri,
              reportPeriodGregorian: fullReport.reportDetails.periodMiladi,
              categoryName: fullReport.reportDetails.type,
            ),
            baseFont,
            boldFont,
          ),
          pw.SizedBox(height: 15),
          _buildOverallReportSection(
            fullReport.overallSummary,
            baseFont,
            boldFont,
            fallbackFont,
          ),
          pw.SizedBox(height: 15),
          buildDetailedReportSection(
            fullReport.detailedReport.data,
            fullReport.detailedReport.headers,
            arabicFont: baseFont,
            arabicFontBold: boldFont,
            fallbackFont: fallbackFont,
          ),
          pw.SizedBox(height: 15),
          buildTajweedAndRecitationSection(
            fullReport.curriculumSchedule.tajweedAndRecitationSchedule,
            baseFont,
            boldFont,
          ),
          pw.SizedBox(height: 15),
          buildAccompanyingCurriculumSection(
            fullReport.curriculumSchedule.accompanyingCurriculum,
            baseFont,
            boldFont,
          ),
        ],
      ),
    ),
  ];
}

pw.Widget _buildOverallReportSection(
  OverallSummary3 summary,
  pw.Font arabicFont,
  pw.Font arabicFontBold,
  pw.Font fallbackFont,
) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      TableHelpers.buildStyledContainer(
        text: 'الإجمالي',
        font: arabicFontBold,
        backgroundColor: TableHelpers.primaryColor,
      ),
      pw.Table(
        border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
        columnWidths: {
          for (int i = 0; i < 8; i++) i: const pw.FlexColumnWidth(1),
        },
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              color: TableHelpers.secondaryContainer,
            ),
            children: [
              TableHelpers.buildHeaderCell(
                text: summary.attendanceDays.label,
                boldFont: arabicFontBold,
              ),
              TableHelpers.buildHeaderCell(
                text: summary.memorizationPagesCount.label,
                boldFont: arabicFontBold,
              ),
              TableHelpers.buildHeaderCell(
                text: summary.memorizationDegreeAverage.label,
                boldFont: arabicFontBold,
              ),
              TableHelpers.buildHeaderCell(
                text: summary.attendanceDaysInCourse.label,
                boldFont: arabicFontBold,
              ),
              TableHelpers.buildHeaderCell(
                text: summary.consistencyRatio.label,
                boldFont: arabicFontBold,
              ),
              TableHelpers.buildHeaderCell(
                text: summary.reviewPagesCount.label,
                boldFont: arabicFontBold,
              ),
              TableHelpers.buildHeaderCell(
                text: summary.reviewAmountWithParts.label,
                boldFont: arabicFontBold,
              ),
              TableHelpers.buildHeaderCell(
                text: summary.reviewDegreeAverage.label,
                boldFont: arabicFontBold,
              ),
            ],
          ),
          pw.TableRow(
            children: [
              TableHelpers.buildCell(
                text: summary.attendanceDays.value.toString(),
                font: arabicFont,
              ),
              TableHelpers.buildCell(
                text: summary.memorizationPagesCount.value.toString(),
                font: arabicFont,
              ),
              TableHelpers.buildGradeCell(
                summary.memorizationDegreeAverage.value,
                arabicFont,
              ),
              TableHelpers.buildCell(
                text: summary.attendanceDaysInCourse.value.toString(),
                font: arabicFont,
              ),
              TableHelpers.buildCell(
                text: summary.consistencyRatio.value.toString(),
                font: arabicFont,
              ),
              TableHelpers.buildCell(
                text: summary.reviewPagesCount.value.toString(),
                font: arabicFont,
              ),
              TableHelpers.buildCell(
                text: summary.reviewAmountWithParts.value.toString(),
                font: arabicFont,
              ),
              TableHelpers.buildGradeCell(
                summary.reviewDegreeAverage.value,
                arabicFont,
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

pw.Widget buildDetailedReportSection(
  List<DailyData> dailyData,
  DetailedReportHeaders headers, {
  required pw.Font arabicFont,
  required pw.Font arabicFontBold,
  required pw.Font fallbackFont,
}) {
  List<pw.Widget> rows = [
    _buildDetailedTableHeader(headers, arabicFontBold),
    ...dailyData.asMap().entries.map(
          (entry) => _buildDailyDataRow(
            entry.key + 1,
            entry.value,
            arabicFont,
            arabicFontBold,
            fallbackFont,
          ),
        ),
  ];

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      TableHelpers.buildStyledContainer(
        text: 'التقرير التفصيلي',
        font: arabicFontBold,
        backgroundColor: TableHelpers.primaryColor,
      ),
      ...rows,
    ],
  );
}

pw.Widget _buildDetailedTableHeader(
  DetailedReportHeaders headers,
  pw.Font arabicFontBold,
) {
  return pw.Column(
    children: [
      _buildDetailedTableHeaderTopRow(headers, arabicFontBold),
      _buildDetailedTableHeaderSubRow(headers, arabicFontBold),
    ],
  );
}

pw.Widget _buildDetailedTableHeaderTopRow(
  DetailedReportHeaders headers,
  pw.Font arabicFontBold,
) {
  return pw.Table(
    border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
    columnWidths: {
      0: const pw.FixedColumnWidth(20), // Number
      1: const pw.FlexColumnWidth(2), // Day
      2: const pw.FlexColumnWidth(4), // Memorization (4 columns)
      3: const pw.FlexColumnWidth(4), // Review (4 columns)
      4: const pw.FlexColumnWidth(4), // Reinforcement (4 columns)
    },
    children: [
      pw.TableRow(
        decoration: const pw.BoxDecoration(
          color: TableHelpers.secondaryContainer,
        ),
        children: [
          _buildDetailedHeaderCell(headers.number, arabicFontBold),
          _buildDetailedHeaderCell(headers.day, arabicFontBold),
          _buildDetailedHeaderCell('الحفظ', arabicFontBold),
          _buildDetailedHeaderCell('المراجعة', arabicFontBold),
          _buildDetailedHeaderCell('التثبيت', arabicFontBold),
        ],
      ),
    ],
  );
}

pw.Widget _buildDetailedTableHeaderSubRow(
  DetailedReportHeaders headers,
  pw.Font arabicFontBold,
) {
  return pw.Table(
    border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
    columnWidths: {
      0: const pw.FixedColumnWidth(20), // Number
      1: const pw.FlexColumnWidth(2), // Day
      2: const pw.FixedColumnWidth(40), // Memorization: from
      3: const pw.FixedColumnWidth(40), // Memorization: to
      4: const pw.FixedColumnWidth(30), // Memorization: pagesCount
      5: const pw.FixedColumnWidth(30), // Memorization: degree
      6: const pw.FixedColumnWidth(40), // Review: from
      7: const pw.FixedColumnWidth(40), // Review: to
      8: const pw.FixedColumnWidth(30), // Review: pagesCount
      9: const pw.FixedColumnWidth(30), // Review: degree
      10: const pw.FixedColumnWidth(40), // Reinforcement: from
      11: const pw.FixedColumnWidth(40), // Reinforcement: to
      12: const pw.FixedColumnWidth(30), // Reinforcement: pagesCount
      13: const pw.FixedColumnWidth(30), // Reinforcement: degree
    },
    children: [
      pw.TableRow(
        decoration: const pw.BoxDecoration(
          color: TableHelpers.tertiaryContainer,
        ),
        children: [
          _buildDetailedHeaderCell('', arabicFontBold),
          _buildDetailedHeaderCell('', arabicFontBold),
          _buildDetailedHeaderCell(headers.memorization.from, arabicFontBold),
          _buildDetailedHeaderCell(headers.memorization.to, arabicFontBold),
          _buildDetailedHeaderCell(
            headers.memorization.pagesCount,
            arabicFontBold,
          ),
          _buildDetailedHeaderCell(headers.memorization.degree, arabicFontBold),
          _buildDetailedHeaderCell(headers.review.from, arabicFontBold),
          _buildDetailedHeaderCell(headers.review.to, arabicFontBold),
          _buildDetailedHeaderCell(headers.review.pagesCount, arabicFontBold),
          _buildDetailedHeaderCell(headers.review.degree, arabicFontBold),
          _buildDetailedHeaderCell(headers.reinforcement.from, arabicFontBold),
          _buildDetailedHeaderCell(headers.reinforcement.to, arabicFontBold),
          _buildDetailedHeaderCell(
            headers.reinforcement.pagesCount,
            arabicFontBold,
          ),
          _buildDetailedHeaderCell(
            headers.reinforcement.degree,
            arabicFontBold,
          ),
        ],
      ),
    ],
  );
}

pw.Widget _buildDailyDataRow(
  int index,
  DailyData dailyData,
  pw.Font arabicFont,
  pw.Font arabicFontBold,
  pw.Font fallbackFont,
) {
  return pw.Table(
    border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
    columnWidths: {
      0: const pw.FixedColumnWidth(20), // Number
      1: const pw.FlexColumnWidth(2), // Day
      2: const pw.FixedColumnWidth(40), // Memorization: from
      3: const pw.FixedColumnWidth(40), // Memorization: to
      4: const pw.FixedColumnWidth(30), // Memorization: pagesCount
      5: const pw.FixedColumnWidth(30), // Memorization: degree
      6: const pw.FixedColumnWidth(40), // Review: from
      7: const pw.FixedColumnWidth(40), // Review: to
      8: const pw.FixedColumnWidth(30), // Review: pagesCount
      9: const pw.FixedColumnWidth(30), // Review: degree
      10: const pw.FixedColumnWidth(40), // Reinforcement: from
      11: const pw.FixedColumnWidth(40), // Reinforcement: to
      12: const pw.FixedColumnWidth(30), // Reinforcement: pagesCount
      13: const pw.FixedColumnWidth(30), // Reinforcement: degree
    },
    children: [
      pw.TableRow(
        children: [
          _buildDetailedCell(index.toString(), arabicFont),
          _buildDetailedCell(dailyData.day, arabicFont),
          _buildDetailedCell(dailyData.memorization?.from ?? '', arabicFont),
          _buildDetailedCell(dailyData.memorization?.to ?? '', arabicFont),
          _buildDetailedCell(
            dailyData.memorization?.pagesCount.toStringAsFixed(2) ?? '',
            arabicFont,
          ),
          TableHelpers.buildGradeCell(
            dailyData.memorization?.degree ?? 0.0,
            arabicFont,
          ),
          _buildDetailedCell(dailyData.review?.from ?? '', arabicFont),
          _buildDetailedCell(dailyData.review?.to ?? '', arabicFont),
          _buildDetailedCell(
            dailyData.review?.pagesCount.toStringAsFixed(2) ?? '',
            arabicFont,
          ),
          TableHelpers.buildGradeCell(
            dailyData.review?.degree ?? 0.0,
            arabicFont,
          ),
          _buildDetailedCell(dailyData.reinforcement?.from ?? '', arabicFont),
          _buildDetailedCell(dailyData.reinforcement?.to ?? '', arabicFont),
          _buildDetailedCell(
            dailyData.reinforcement?.pagesCount.toStringAsFixed(2) ?? '',
            arabicFont,
          ),
          TableHelpers.buildGradeCell(
            dailyData.reinforcement?.degree ?? 0.0,
            arabicFont,
          ),
        ],
      ),
    ],
  );
}

pw.Widget _buildDetailedCell(String text, pw.Font arabicFont) {
  return pw.Container(
    alignment: pw.Alignment.centerRight,
    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
    decoration: pw.BoxDecoration(
      color: PdfColors.white, // Uniform background color
      border: pw.Border.all(width: 0.5, color: PdfColors.grey400),
    ),
    child: pw.Text(
      text.isEmpty ? ' ' : text, // Use a space if empty to fill the area
      textDirection: pw.TextDirection.rtl,
      style: pw.TextStyle(font: arabicFont, fontSize: 8),
      textAlign: pw.TextAlign.right,
      maxLines: 1,
      overflow: pw.TextOverflow.clip,
    ),
  );
}

pw.Widget _buildDetailedHeaderCell(String text, pw.Font arabicFontBold) {
  return pw.Container(
    alignment: pw.Alignment.centerRight,
    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
    decoration: pw.BoxDecoration(
      color: TableHelpers.secondaryContainer, // Match header background
      border: pw.Border.all(width: 0.5, color: PdfColors.grey400),
    ),
    child: pw.Text(
      text.isEmpty ? ' ' : text, // Use a space if empty to fill the area
      textDirection: pw.TextDirection.rtl,
      style: pw.TextStyle(
        font: arabicFontBold,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.right,
      maxLines: 1,
      overflow: pw.TextOverflow.clip,
    ),
  );
}
