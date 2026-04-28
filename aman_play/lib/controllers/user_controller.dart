import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
 
 var userName = "وجد الخميس".obs;
 var userEmail = "user1234@gmail.com".obs;
 var userPhone = "0512345678".obs;
 var isLoading = false.obs;

 final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 void updateUserData(String name, String email, String phone){
  userName.value = name;
  userEmail.value = email;
  userPhone.value = phone;
 }

 // Fetch user data from Firestore
 Future<void> fetchUserData(String uid) async {
  try {
   isLoading.value = true;
   final userDoc = await _firestore.collection('users').doc(uid).get();
   
   if (userDoc.exists) {
    final data = userDoc.data();
    if (data != null) {
     userName.value = data['name'] ?? 'وجد الخميس';
     userEmail.value = data['email'] ?? '';
    }
   }
  } catch (e) {
   print("Error fetching user data: $e");
  } finally {
   isLoading.value = false;
  }
 }
}