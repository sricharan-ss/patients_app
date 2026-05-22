import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/backend_config.dart';
import '../core/session_store.dart';

class PatientApiService {
  static Uri _uri(String path, [Map<String, String?> query = const {}]) {
    final filtered = <String, String>{};
    query.forEach((key, value) {
      if (value != null && value.trim().isNotEmpty) {
        filtered[key] = value;
      }
    });
    final base = Uri.parse('${BackendConfig.baseUrl}$path');
    return filtered.isEmpty ? base : base.replace(queryParameters: filtered);
  }

  static Map<String, String> _headers() {
    final token = SessionStore.accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<PatientHospital>> getHospitals() async {
    final data = await _getList('/api/mobile/patient/hospitals');
    return data.map(PatientHospital.fromJson).toList();
  }

  static Future<PatientHospitalDetail> getHospital(String id) async {
    final data = await _getMap('/api/mobile/patient/hospitals/$id');
    return PatientHospitalDetail.fromJson(data);
  }

  static Future<List<PatientDoctor>> getDoctors({
    String? query,
    String? hospitalId,
    String? specialization,
  }) async {
    final data = await _getList('/api/mobile/patient/doctors', {
      'q': query,
      'hospitalId': hospitalId,
      'specialization': specialization,
    });
    return data.map(PatientDoctor.fromJson).toList();
  }

  static Future<List<PatientSlot>> getDoctorSlots({
    required String doctorId,
    required DateTime date,
    String? hospitalId,
  }) async {
    final dateText =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final data = await _getList('/api/mobile/patient/doctors/$doctorId/slots', {
      'date': dateText,
      'hospitalId': hospitalId,
    });
    return data.map(PatientSlot.fromJson).toList();
  }

  static Future<PatientAppointment> createAppointment({
    required String doctorId,
    required String hospitalId,
    required DateTime scheduledTime,
    required String reason,
    String? notes,
    int duration = 30,
  }) async {
    final data = await _postMap('/api/mobile/patient/appointments', {
      'doctorId': doctorId,
      'hospitalId': hospitalId,
      'scheduledTime': scheduledTime.toUtc().toIso8601String(),
      'duration': duration,
      'reason': reason,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
    });
    return PatientAppointment.fromJson(data);
  }

  static Future<List<PatientAppointment>> getAppointments() async {
    final data = await _getList('/api/mobile/patient/appointments');
    return data.map(PatientAppointment.fromJson).toList();
  }

  static Future<PatientRecords> getRecords() async {
    final data = await _getMap('/api/mobile/patient/records');
    return PatientRecords.fromJson(data);
  }

  static Future<Map<String, dynamic>> getMedicationDashboard() async {
    return _getMap('/api/mobile/patient/medications/dashboard');
  }

  static Future<List<Map<String, dynamic>>> getMedicationOrders({
    String? status,
    int? limit,
  }) async {
    final data = await _getList('/api/mobile/patient/medications/orders', {
      'status': status,
      if (limit != null) 'limit': '$limit',
    });
    return _mapList(data);
  }

  static Future<Map<String, dynamic>> getMedicationOrderById(String orderId) async {
    return _getMap('/api/mobile/patient/medications/orders/$orderId');
  }

  static Future<Map<String, dynamic>> createMedicationRefill({
    String? prescriptionId,
    String? hospitalId,
    String? notes,
    List<Map<String, dynamic>> items = const [],
  }) async {
    return _postMap('/api/mobile/patient/medications/refill', {
      if (prescriptionId != null && prescriptionId.trim().isNotEmpty)
        'prescriptionId': prescriptionId.trim(),
      if (hospitalId != null && hospitalId.trim().isNotEmpty)
        'hospitalId': hospitalId.trim(),
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      if (items.isNotEmpty) 'items': items,
    });
  }

  static Future<Map<String, dynamic>> createMedicationOrder({
    String? hospitalId,
    String? sourcePrescriptionId,
    String orderType = 'NEW',
    String? notes,
    DateTime? expectedDeliveryAt,
    List<Map<String, dynamic>> items = const [],
  }) async {
    return _postMap('/api/mobile/patient/medications/orders', {
      if (hospitalId != null && hospitalId.trim().isNotEmpty)
        'hospitalId': hospitalId.trim(),
      if (sourcePrescriptionId != null && sourcePrescriptionId.trim().isNotEmpty)
        'sourcePrescriptionId': sourcePrescriptionId.trim(),
      'orderType': orderType,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      if (expectedDeliveryAt != null)
        'expectedDeliveryAt': expectedDeliveryAt.toUtc().toIso8601String(),
      'items': items,
    });
  }

  static Future<List<dynamic>> _getList(
    String path, [
    Map<String, String?> query = const {},
  ]) async {
    final decoded = await _request(
      () => http.get(_uri(path, query), headers: _headers()),
    );
    final data = decoded['data'];
    if (data is List) return data;
    return const [];
  }

  static Future<Map<String, dynamic>> _getMap(String path) async {
    final decoded = await _request(
      () => http.get(_uri(path), headers: _headers()),
    );
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    return <String, dynamic>{};
  }

  static Future<Map<String, dynamic>> _postMap(
    String path,
    Map<String, dynamic> body,
  ) async {
    final decoded = await _request(
      () => http.post(_uri(path), headers: _headers(), body: jsonEncode(body)),
    );
    final data = decoded['data'];
    if (data is Map<String, dynamic>) return data;
    return <String, dynamic>{};
  }

  static Future<Map<String, dynamic>> _request(
    Future<http.Response> Function() action,
  ) async {
    try {
      final response = await action();
      final decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      }
      throw PatientApiException(
        decoded['message']?.toString() ??
            'Request failed with HTTP ${response.statusCode}',
      );
    } catch (error) {
      if (error is PatientApiException) rethrow;
      throw PatientApiException(
        'Unable to reach backend at ${BackendConfig.baseUrl}. Make sure the server is running.',
      );
    }
  }
}

class PatientApiException implements Exception {
  final String message;

  const PatientApiException(this.message);

  @override
  String toString() => message;
}

class PatientHospital {
  final String id;
  final String name;
  final String city;
  final String address;
  final double rating;
  final List<String> tags;
  final int doctorCount;

  const PatientHospital({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.rating,
    required this.tags,
    required this.doctorCount,
  });

  factory PatientHospital.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return PatientHospital(
      id: _string(map['id']),
      name: _string(map['name'], 'Hospital'),
      city: _string(map['city'], 'Unknown'),
      address: _string(map['address']),
      rating: _double(map['rating'], 4.5),
      tags: _stringList(map['tags']),
      doctorCount: _int(map['doctorCount']),
    );
  }
}

class PatientHospitalDetail extends PatientHospital {
  final List<PatientDoctor> doctors;
  final List<PatientLab> labs;

  const PatientHospitalDetail({
    required super.id,
    required super.name,
    required super.city,
    required super.address,
    required super.rating,
    required super.tags,
    required super.doctorCount,
    required this.doctors,
    required this.labs,
  });

  factory PatientHospitalDetail.fromJson(Map<String, dynamic> map) {
    final base = PatientHospital.fromJson(map);
    return PatientHospitalDetail(
      id: base.id,
      name: base.name,
      city: base.city,
      address: base.address,
      rating: base.rating,
      tags: base.tags,
      doctorCount: base.doctorCount,
      doctors: _list(map['doctors']).map(PatientDoctor.fromJson).toList(),
      labs: _list(map['labs']).map(PatientLab.fromJson).toList(),
    );
  }
}

class PatientDoctor {
  final String id;
  final String name;
  final String specialty;
  final String? specialization;
  final String? hospitalId;
  final String hospitalName;
  final double rating;
  final int reviewCount;
  final int totalPatients;
  final int experience;
  final int fee;
  final bool isAvailable;

  const PatientDoctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.specialization,
    required this.hospitalId,
    required this.hospitalName,
    required this.rating,
    required this.reviewCount,
    required this.totalPatients,
    required this.experience,
    required this.fee,
    required this.isAvailable,
  });

  factory PatientDoctor.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return PatientDoctor(
      id: _string(map['id']),
      name: _string(map['name'], 'Doctor'),
      specialty: _string(map['specialty'], 'General Practice'),
      specialization: _nullableString(map['specialization']),
      hospitalId: _nullableString(map['hospitalId']),
      hospitalName: _string(map['hospitalName'], 'VITADATA Hospital'),
      rating: _double(map['rating'], 4.6),
      reviewCount: _int(map['reviewCount'], 120),
      totalPatients: _int(map['totalPatients'], 500),
      experience: _int(map['experience'], 8),
      fee: _int(map['fee'], 500),
      isAvailable: map['isAvailable'] != false,
    );
  }
}

class PatientSlot {
  final String time;
  final bool available;

  const PatientSlot({required this.time, required this.available});

  factory PatientSlot.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return PatientSlot(
      time: _string(map['time']),
      available: map['available'] != false,
    );
  }
}

class PatientAppointment {
  final String id;
  final DateTime? scheduledTime;
  final int duration;
  final int tokenNo;
  final String status;
  final String? reason;
  final PatientDoctor? doctor;
  final PatientHospital? hospital;

  const PatientAppointment({
    required this.id,
    required this.scheduledTime,
    required this.duration,
    required this.tokenNo,
    required this.status,
    required this.reason,
    required this.doctor,
    required this.hospital,
  });

  factory PatientAppointment.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    final doctorMap = map['doctor'];
    final hospitalMap = map['hospital'];
    return PatientAppointment(
      id: _string(map['id']),
      scheduledTime: _date(map['scheduledTime']),
      duration: _int(map['duration'], 30),
      tokenNo: _int(map['tokenNo']),
      status: _string(map['status'], 'SCHEDULED'),
      reason: _nullableString(map['reason']),
      doctor: doctorMap is Map<String, dynamic>
          ? PatientDoctor.fromJson(doctorMap)
          : null,
      hospital: hospitalMap is Map<String, dynamic>
          ? PatientHospital.fromJson(hospitalMap)
          : null,
    );
  }
}

class PatientLab {
  final String id;
  final String name;

  const PatientLab({required this.id, required this.name});

  factory PatientLab.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return PatientLab(
      id: _string(map['id']),
      name: _string(map['name'], 'Lab'),
    );
  }
}

class PatientRecords {
  final List<PatientAppointment> appointments;
  final List<Map<String, dynamic>> prescriptions;
  final List<Map<String, dynamic>> labReports;
  final List<Map<String, dynamic>> vault;
  final List<Map<String, dynamic>> medications;

  const PatientRecords({
    required this.appointments,
    required this.prescriptions,
    required this.labReports,
    required this.vault,
    required this.medications,
  });

  factory PatientRecords.fromJson(Map<String, dynamic> map) {
    return PatientRecords(
      appointments: _list(
        map['appointments'],
      ).map(PatientAppointment.fromJson).toList(),
      prescriptions: _mapList(map['prescriptions']),
      labReports: _mapList(map['labReports']),
      vault: _mapList(map['vault']),
      medications: _mapList(map['medications']),
    );
  }
}

String _string(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  return text.isEmpty ? fallback : text;
}

String? _nullableString(dynamic value) {
  final text = _string(value);
  return text.isEmpty ? null : text;
}

int _int(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _double(dynamic value, [double fallback = 0]) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

DateTime? _date(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString())?.toLocal();
}

List<dynamic> _list(dynamic value) {
  return value is List ? value : const [];
}

List<String> _stringList(dynamic value) {
  return _list(value)
      .map((item) => item.toString())
      .where((item) => item.trim().isNotEmpty)
      .toList();
}

List<Map<String, dynamic>> _mapList(dynamic value) {
  return _list(value)
      .whereType<Map>()
      .map((item) => item.map(
            (key, val) => MapEntry(key.toString(), val),
          ))
      .toList();
}
