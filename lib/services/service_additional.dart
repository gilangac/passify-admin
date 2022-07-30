// ignore_for_file: prefer_const_constructors

import 'package:intl/intl.dart';

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 minggu lalu' : 'Minggu lalu';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 hari yang lalu' : 'Kemarin';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 jam yang lalu' : 'Satu jam yang lalu';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 menit yang lalu' : 'Satu menit yang lalu';
    }
    // else if (difference.inSeconds >= 3) {
    //   return '${difference.inSeconds} detik yang lalu';
    // }
    else {
      return 'Baru saja';
    }
  }
}

class TimeAgo2 {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if ((difference.inDays / 360).floor() >= 1) {
      return '${(difference.inDays / 360).floor()} tahun';
    } else if ((difference.inDays / 360).floor() >= 1) {
      return (numericDates) ? '1 tahun' : 'Tahun';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return '${(difference.inDays / 30).floor()} bulan';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 bulan' : 'Bulan';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return '${(difference.inDays / 7).floor()} minggu';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 minggu' : 'Minggu';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} hari';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 hari' : 'Kemarin';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} jam';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 jam' : 'Satu jam';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} menit';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 menit' : '1 menit';
    }
    // else if (difference.inSeconds >= 3) {
    //   return '${difference.inSeconds} detik';
    // }
    else {
      return 'Baru saja';
    }
  }
}

