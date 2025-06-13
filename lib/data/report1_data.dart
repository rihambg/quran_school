import '../system/models/shared.dart';
import '../system/models/report1_model.dart';

FullReport createSampleReport() {
  return FullReport<OverallSummary1>(
    reportTitle: "تقرير الطالب (ة) : عاصم بحري",
    reportDetails: ReportDetails(
      schoolName: "اسم المدرسة",
      teacherName: "اسم المعلم",
      reportPeriod: "فترة التقرير",
      distinguishedSchool: "المدرسة المتميزة",
      courseName: "اسم الحلقة",
      type: "الفئة",
      schoolValue: "رمضان بحري",
      courseValue: "حلقة الشيخ رمضان بحري",
      periodHijri: "من 30 رمضان 1443 هـ الى 1 ذو القعدة 1443 هـ",
      periodMiladi: "من 01 ماي 2022 م الى 31 ماي 2022 م",
    ),
    overallSummary: OverallSummary1(
      reinforcementLog: StatItem(label: 'التثبيت', value: '58.18'),
      reviewPages: StatItem(label: 'صفحات المراجعة', value: '37.93'),
      memorizationPages: StatItem(label: 'صفحات الحفظ', value: '20.68'),
      studyCircleStudentCount: StatItem(label: 'عدد طلاب الحلقة', value: '8'),
    ),
    detailedReport: DetailedReport(
      headers: DetailedReportHeaders(
        number: "م",
        day: "اليوم",
        memorization: SectionHeaders(
          from: "من",
          to: "إلى",
          pagesCount: "الصفحات",
          degree: "الدرجة",
        ),
        review: SectionHeaders(
          from: "من",
          to: "إلى",
          pagesCount: "الصفحات",
          degree: "الدرجة",
        ),
        reinforcement: SectionHeaders(
          from: "من",
          to: "إلى",
          pagesCount: "الصفحات",
          degree: "الدرجة",
        ),
      ),
      data: [
        DailyData(
          number: 1,
          day: "الجمعة 06 ماي 2022",
          memorization: DailySectionData(
            from: "البقرة 20",
            to: "البقرة 1",
            pagesCount: 1.75,
            degree: 10.00,
          ),
        ),
        DailyData(
          number: 2,
          day: "السبت 07 ماي 2022",
          memorization: DailySectionData(
            from: "آل عمران 30",
            to: "آل عمران 1",
            pagesCount: 4.03,
            degree: 20.00,
          ),
        ),
        DailyData(
          number: 3,
          day: "الاحد 08 ماي 2022",
          memorization: DailySectionData(
            from: "الحجرات 18",
            to: "المطففين 1",
            pagesCount: 5.29,
            degree: 10.00,
          ),
        ),
        DailyData(
          number: 4,
          day: "السبت 07 ماي 2022",
          review: DailySectionData(
            from: "النساء 6",
            to: "البقرة 1",
            pagesCount: 5.29,
            degree: 10.00,
          ),
        ),
        DailyData(
          number: 5,
          day: "الجمعة 06 ماي 2022",
          review: DailySectionData(
            from: "التوبة 1",
            to: "الأعلى 1",
            pagesCount: 5.29,
            degree: 10.00,
          ),
        ),
        DailyData(
          number: 6,
          day: "السبت 07 ماي 2022",
          reinforcement: DailySectionData(
            from: "النجم 1",
            to: "الحديد 1",
            pagesCount: 11.25,
            degree: 15.00,
          ),
        ),
        DailyData(
          number: 7,
          day: "الاحد 08 ماي 2022",
          reinforcement: DailySectionData(
            from: "الطارق 17",
            to: "الطارق 17",
            pagesCount: 8.27,
            degree: 18.50,
          ),
        ),
        DailyData(
          number: 8,
          day: "السبت 07 ماي 2022",
          review: DailySectionData(
            from: "الجن 1",
            to: "الطارق 17",
            pagesCount: 17.47,
            degree: 17.00,
          ),
        ),
        DailyData(
          number: 9,
          day: "الجمعة 06 ماي 2022",
          reinforcement: DailySectionData(
            from: "الجمعة 1",
            to: "المرسلات 50",
            pagesCount: 26.87,
            degree: 17.00,
          ),
        ),
      ],
    ),
    curriculumSchedule: CurriculumSchedule(
      tajweedAndRecitationSchedule: TajweedAndRecitationSchedule(
        title: "الجدول التجويدي والتلاوة",
        lessons: [
          Lesson(
            id: 1,
            day: "الجمعة",
            recitationTopic: "سورة البقرة",
            tajweedTopic: "أحكام النون الساكنة",
          ),
          Lesson(
            id: 2,
            day: "السبت",
            recitationTopic: "سورة آل عمران",
            tajweedTopic: "القلقلة",
          ),
        ],
      ),
      accompanyingCurriculum: AccompanyingCurriculum(
        title: "المنهج المصاحب",
        lessons: [
          AccompanyingLesson(
            id: 1,
            day: "الجمعة",
            subject: "الدرس الأول",
            lessonTitle: "أخلاق المسلم",
          ),
        ],
      ),
    ),
  );
}
