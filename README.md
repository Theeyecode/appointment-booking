# appointment_booking_app

A new Flutter project.

## Getting Started


Below is a sample README for your appointment booking app, tailored to include the key features and instructions for getting started.

Appointment Booking App
The Appointment Booking App is a Flutter-based mobile application that enables users to register and select a user type—either Customer or Merchant. It facilitates merchants in creating available time slots, which customers can then book according to their convenience.

**Features**
- User Registration: Users can create an account with their email.
User Type Selection: Upon registration, users must select their role within the app: Customer or - -
- Merchant.
Time Slot Creation (Merchants): Merchants can create available time slots specifying the start and end times.
Time Slot Management (Merchants): Merchants have the flexibility to edit or delete their time slots. This feature ensures that merchants can easily manage their schedules and make necessary adjustments.
- Appointment Booking (Customers): Customers can view available time slots and book them.
Getting Started
To get a local copy up and running, follow these simple steps:

**Prerequisites**
Flutter installed on your machine. Install Flutter
An IDE (VSCode, Android Studio, or IntelliJ IDEA) with Flutter plugin installed.
An emulator or physical device to run the app.

**After Installation**
cd appointment_booking_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run


**Limitations and Considerations**
Non-deletable Booked Time Slots: Merchants are unable to delete time slots that have already been booked by customers. This constraint ensures that customers' bookings remain valid and undisrupted, promoting reliability in the booking process.

Handling of Past Dates: The application does not automatically delete past dates from the database due to the cost implications of using Firebase Functions for such operations. While it is possible to manage past dates on the frontend to improve user experience, this approach is avoided to prevent potential performance issues. Users and merchants are encouraged to manually manage their schedules within the app for efficiency.

**Architectural Ommittion**
I avoided the uses of Abstract classes to keep things simple, only had the cause to use it during the Authentication Services