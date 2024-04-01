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

  // Future<List<Merchant>> fetchMerchants() async {
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   try {
  //     QuerySnapshot querySnapshot = await _db
  //         .collection('merchants')
  //         .orderBy('created_at', descending: false)
  //         .get();
  //     List<Merchant> merchants = querySnapshot.docs.map((doc) {
  //       return Merchant.fromMap(doc.data() as Map<String, dynamic>);
  //     }).toList();
  //     print('Merchants :${merchants.length}');
  //     return merchants;
  //   } catch (e) {
  //     print("Error fetching merchants: $e");
  //     return [];
  //   }
  // }
  Stream<List<Merchant>> fetchMerchants() {
    return _db
        .collection('merchants')
        .orderBy('created_at', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Merchant.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
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

  Stream<List<Appointment>> fetchMerchantAppointmentsStream(String merchantId) {
    print('got here nahh1');

    return _db
        .collection('appointments')
        .where('merchantId', isEqualTo: merchantId)
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
