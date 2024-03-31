import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/customer.dart';

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<Customer> fetchOrCreateCustomer(String customerId,
      {String? name}) async {
    DocumentReference customerRef =
        _firestore.collection('customers').doc(customerId);
    try {
      DocumentSnapshot customerSnapshot = await customerRef.get();

      if (customerSnapshot.exists) {
        return Customer.fromMap(
            customerSnapshot.data() as Map<String, dynamic>);
      } else {
        Customer newCustomer = Customer(
          id: customerId,
          name: name ?? 'New Customer',
          appointments: [],
        );
        await customerRef.set(newCustomer.toMap());

        return newCustomer;
      }
    } catch (e) {
      print("Error fetching customer: $e");
    }
    return Customer(id: '', name: '', appointments: []);
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _firestore
          .collection('customers')
          .doc(customer.id)
          .update(customer.toMap());
    } catch (e) {
      print("Error updating customer: $e");
      throw e; // Re-throw the error to handle it in the calling code.
    }
  }

  Future<bool> addAppointmentToCustomer(
      String customerId, String merchantId, String timeSlotId) async {
    try {
      DocumentReference customerRef =
          _firestore.collection('customers').doc(customerId);

      // Create the new appointment object
      Map<String, dynamic> newAppointment = {
        'merchantId': merchantId,
        'timeSlotId': timeSlotId,
      };

      // Update the customer's appointments array
      await customerRef.update({
        'appointments': FieldValue.arrayUnion([newAppointment]),
      });

      return true;
    } catch (e) {
      print("Error adding appointment to customer: $e");
      return false;
    }
  }
}
