import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/appointment.dart';
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
        );
        await customerRef.set(newCustomer.toMap());

        return newCustomer;
      }
    } catch (e) {
      print("Error fetching customer: $e");
    }
    return Customer(
      id: '',
      name: '',
    );
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _firestore
          .collection('customers')
          .doc(customer.id)
          .update(customer.toMap());
    } catch (e) {
      print("Error updating customer: $e");
      rethrow; // Re-throw the error to handle it in the calling code.
    }
  }

  Future<bool> addAppointmentToCustomer(
      String customerId, Appointment appointment) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(appointment.toMap());
      print('Appointment added successfully for customer ID: $customerId');
      return true;
    } catch (e) {
      print(
          'Failed to add appointment for customer ID: $customerId, Error: $e');
      return false;
    }
  }

  Stream<List<Appointment>> fetchCustomerAppointmentsStream(String customerId) {
    return _firestore
        .collection('appointments')
        .where('customerId', isEqualTo: customerId)
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Appointment.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
