import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/merchants.dart'; // Adjust import path as necessary

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
        Merchant newMerchant = Merchant(
          id: merchantId,
          name: name ?? 'New Merchant',
          availableTimeSlots: [],
        );
        await merchantRef.set(newMerchant.toMap());

        return newMerchant;
      }
    } catch (e) {
      print("Error fetching merchant: $e");
    }
    return Merchant(id: '', name: '', availableTimeSlots: []);
  }

  // Update a merchant's availability
  Future<bool> updateMerchantAvailability(
      String merchantId, List<TimeSlot> slots) async {
    try {
      print('slotMaps: i want to see this');
      // Convert the List<TimeSlot> to a format suitable for Firestore.
      List<Map<String, dynamic>> slotMaps =
          slots.map((slot) => slot.toMap()).toList();

      print('slotMaps: $slotMaps');

      // Use the Firestore instance to access the 'merchants' collection and then the specific merchant document.
      // Use set with SetOptions(merge: true) to either create the document or merge the fields.
      await _db.collection('merchants').doc(merchantId).set({
        'availableTimeSlots': slotMaps,
      }, SetOptions(merge: true));
      print('slotMaps: i want to see this 2');

      // If the operation is successful, return true.
      return true;
    } catch (e) {
      // If there is an error during the operation, print it to the console and return false.
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
      return []; // Return an empty list if no slots are found or the merchant doesn't exist
    } catch (e) {
      print("Error fetching merchant time slots: $e");
      return []; // Return an empty list in case of error
    }
  }

  Future<bool> deleteTimeSlot(String merchantId, TimeSlot slotToDelete) async {
    try {
      // Get a reference to the merchant's document
      var merchantDoc = _db.collection('merchants').doc(merchantId);

      // Perform a transaction to safely delete the time slot
      return _db.runTransaction((transaction) async {
        // Get the document snapshot
        var snapshot = await transaction.get(merchantDoc);

        if (!snapshot.exists) {
          throw Exception("Merchant not found!");
        }

        // Get current list of time slots
        var slots = List.from(snapshot.data()?['availableTimeSlots'] ?? []);

        // Determine which slot to remove
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
    try {
      QuerySnapshot querySnapshot = await _db.collection('merchants').get();
      List<Merchant> merchants = querySnapshot.docs.map((doc) {
        return Merchant.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return merchants;
    } catch (e) {
      print("Error fetching merchants: $e");
      return [];
    }
  }
}
