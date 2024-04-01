// ignore_for_file: avoid_print

import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../customer/models/appointment.dart';
import '../models/merchants.dart';

class MerchantService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  // Fetch merchant data; create a new document if it doesn't exist
  Future<Merchant> fetchOrCreateMerchant(String merchantId,
      {String? name}) async {
    DocumentReference merchantRef = _db.collection('merchants').doc(merchantId);
    try {
      DocumentSnapshot merchantSnapshot = await merchantRef.get();

      if (merchantSnapshot.exists) {
        return Merchant.fromMap(
            merchantSnapshot.data() as Map<String, dynamic>);
      } else {
        DateTime now = DateTime.now();
        Merchant newMerchant = Merchant(
          id: merchantId,
          name: name ?? 'New Merchant',
          availableTimeSlots: [],
          createdAt: now,
        );
        await merchantRef.set(newMerchant.toMap());

        return newMerchant;
      }
    } catch (e) {
      print("Error fetching merchant: $e");
    }
    return Merchant(
        id: '', name: '', availableTimeSlots: [], createdAt: DateTime.now());
  }

  // Update a merchant's availability
  Future<bool> updateMerchantAvailability(
      String merchantId, List<TimeSlot> slots) async {
    try {
      List<Map<String, dynamic>> slotMaps =
          slots.map((slot) => slot.toMap()).toList();

      await _db.collection('merchants').doc(merchantId).set({
        'availableTimeSlots': slotMaps,
      }, SetOptions(merge: true));

      // If the operation is successful, return true.
      return true;
    } catch (e) {
      print("Error setting merchant availability: $e");
      return false;
    }
  }

  Future<List<TimeSlot>> fetchMerchantTimeSlots(String merchantId) async {
    try {
      DocumentSnapshot merchantSnapshot =
          await _db.collection('merchants').doc(merchantId).get();
      if (merchantSnapshot.exists) {
        var merchantData = merchantSnapshot.data() as Map<String, dynamic>;
        if (merchantData.containsKey('availableTimeSlots')) {
          List<dynamic> slotsData = merchantData['availableTimeSlots'];
          List<TimeSlot> slots =
              slotsData.map((slotData) => TimeSlot.fromMap(slotData)).toList();
          return slots;
        }
      }
      return [];
    } catch (e) {
      print("Error fetching merchant time slots: $e");
      return [];
    }
  }

  Future<bool> deleteTimeSlot(String merchantId, TimeSlot slotToDelete) async {
    try {
      var merchantDoc = _db.collection('merchants').doc(merchantId);

      return _db.runTransaction((transaction) async {
        // Get the document snapshot
        var snapshot = await transaction.get(merchantDoc);

        if (!snapshot.exists) {
          throw Exception("Merchant not found!");
        }

        var slots = List.from(snapshot.data()?['availableTimeSlots'] ?? []);

        slots.removeWhere((slot) => slot['id'] == slotToDelete.id);

        // Update the document with the new list
        transaction.update(merchantDoc, {'availableTimeSlots': slots});

        return true; // Success
      });
    } catch (e) {
      print("Error deleting time slot: $e");
      return false; // Failure
    }
  }

  Future<List<Merchant>> fetchMerchants() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('merchants')
          .orderBy('created_at', descending: false)
          .get();
      List<Merchant> merchants = querySnapshot.docs.map((doc) {
        return Merchant.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      print('Merchants :${merchants.length}');
      return merchants;
    } catch (e) {
      print("Error fetching merchants: $e");
      return [];
    }
  }

  Future<bool> markSlotsAsBooked(String merchantId, Set<String> slotIds) async {
    DocumentReference merchantRef = _db.collection('merchants').doc(merchantId);
    try {
      var merchantSnapshot = await merchantRef.get();
      if (!merchantSnapshot.exists) throw Exception("Merchant not found!");

      var merchantData = merchantSnapshot.data() as Map<String, dynamic>;
      var slotsData = List<Map<String, dynamic>>.from(
          merchantData['availableTimeSlots'] ?? []);

      // Mark selected slots
      for (var slot in slotsData) {
        if (slotIds.contains(slot['id'])) {
          slot['booked'] = true;
        }
      }

      // Save updated slots back to Firestore
      await merchantRef.update({'availableTimeSlots': slotsData});
      return true;
    } catch (e) {
      print("Error marking slots as bookeds: $e");
      return false;
    }
  }

  Stream<List<Appointment>> fetchAppointmentsByCustomerStream() {
    final customerId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromMap(doc.data()))
            .toList());
  }

  Future<MerchantBookingDetail> fetchMerchantAndTimeSlotDetails(
      Appointment appointment) async {
    try {
      // Fetch merchant details
      DocumentSnapshot merchantSnapshot = await FirebaseFirestore.instance
          .collection('merchants')
          .doc(appointment.merchantId)
          .get();
      if (!merchantSnapshot.exists) {
        throw Exception("Merchant not found");
      }
      Merchant merchant =
          Merchant.fromMap(merchantSnapshot.data() as Map<String, dynamic>);

      // Assuming the timeslot ID is directly accessible and you have a method or a way to fetch it
      TimeSlot? timeSlot;
      for (var slotData in merchant.availableTimeSlots ?? []) {
        if (slotData.id == appointment.timeSlotId) {
          timeSlot = slotData;
          break;
        }
      }

      if (timeSlot == null) {
        throw Exception("TimeSlot not found");
      }

      return MerchantBookingDetail(
        appointmentId: appointment.id,
        merchantName: merchant.name,
        timeSlot: timeSlot,
        // Optional, if you want to include customer name in details
      );
    } catch (e) {
      print("Error fetching merchant and time slot details: $e");
      // Handle error, perhaps by returning a placeholder detail or re-throwing the exception
      throw Exception("Failed to fetch details");
    }
  }

  Stream<List<Appointment>> fetchAppointmentsByMerchantStream() {
    final merchantId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('merchantId', isEqualTo: merchantId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromMap(doc.data()))
            .toList());
  }

  Future<CustomerBookingDetail> fetchCustomerAndTimeSlotDetails(
      Appointment appointment) async {
    try {
      // Fetch merchant details
      DocumentSnapshot merchantSnapshot = await FirebaseFirestore.instance
          .collection('merchants')
          .doc(appointment.merchantId)
          .get();
      if (!merchantSnapshot.exists) {
        throw Exception("Merchant not found");
      }

      var customerSnapshot =
          await _db.collection('customers').doc(appointment.customerId).get();
      String customerName = customerSnapshot.data()?['name'] ?? 'Unknown';

      Merchant merchant =
          Merchant.fromMap(merchantSnapshot.data() as Map<String, dynamic>);

      // Assuming the timeslot ID is directly accessible and you have a method or a way to fetch it
      TimeSlot? timeSlot;
      for (var slotData in merchant.availableTimeSlots ?? []) {
        if (slotData.id == appointment.timeSlotId) {
          timeSlot = slotData;
          break;
        }
      }

      if (timeSlot == null) {
        throw Exception("TimeSlot not found");
      }

      return CustomerBookingDetail(
        appointmentId: appointment.id,
        customerName: customerName,
        timeSlot: timeSlot,
        // Optional, if you want to include customer name in details
      );
    } catch (e) {
      print("Error fetching merchant and time slot details: $e");
      // Handle error, perhaps by returning a placeholder detail or re-throwing the exception
      throw Exception("Failed to fetch details");
    }
  }
}


 // Future<List<CustomerBookingDetail>> fetchAppointmentsByMerchant(
  //     String merchantId) async {
  //   try {
  //     final querySnapshot = await _db
  //         .collection('appointments')
  //         .where('merchantId', isEqualTo: merchantId)
  //         .get();

  //     List<CustomerBookingDetail> appointmentDetails = [];
  //     for (var doc in querySnapshot.docs) {
  //       var appointmentData = doc.data();
  //       if (appointmentData == null ||
  //           appointmentData is! Map<String, dynamic>) {
  //         continue;
  //       }
  //       var appointment = Appointment.fromMap(appointmentData);

  //       // Fetch customer name
  //       var customerSnapshot =
  //           await _db.collection('customers').doc(appointment.customerId).get();
  //       String customerName = customerSnapshot.data()?['name'] ?? 'Unknown';

  //       // Fetch merchant document to get availableTimeSlots
  //       var merchantSnapshot =
  //           await _db.collection('merchants').doc(merchantId).get();
  //       var merchantData = merchantSnapshot.data();
  //       TimeSlot timeSlot;

  //       if (merchantData != null) {
  //         List<dynamic> timeSlotsData =
  //             merchantData['availableTimeSlots'] ?? [];
  //         var timeSlotData = timeSlotsData.firstWhere(
  //           (t) => t['id'] == appointment.timeSlotId,
  //           orElse: () => null,
  //         );

  //         if (timeSlotData != null) {
  //           timeSlot = TimeSlot.fromMap(timeSlotData as Map<String, dynamic>);
  //         } else {
  //           continue;
  //         }
  //       } else {
  //         continue;
  //       }

  //       appointmentDetails.add(CustomerBookingDetail(
  //         appointmentId: doc.id,
  //         customerName: customerName,
  //         timeSlot: timeSlot,
  //       ));
  //     }
  //     return appointmentDetails;
  //   } catch (e) {
  //     print("Error fetching appointments: $e");
  //     return [];
  //   }
  // }