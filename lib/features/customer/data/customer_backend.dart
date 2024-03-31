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
}
