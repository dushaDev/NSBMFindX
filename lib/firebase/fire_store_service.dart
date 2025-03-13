import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_x/random.dart';

import 'models/Faculty.dart';
import 'models/Student.dart';
import 'models/admin.dart';
import 'models/degree_program.dart';
import 'models/found_item.dart';
import 'models/lost_item.dart';
import 'models/staff.dart';
import 'models/user_m.dart';

//this changes for testing purposes //2025-03-01
class FireStoreService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Random _random = Random();

  Future<void> registerStudent(
    String id,
    String name,
    String email,
    String role,
    String facultyId,
    String degreeProgramId,
    String about,
  ) async {
    List<String> words = _random.splitName(name);

    await addUser(UserM(
            id: id,
            name: name,
            displayName: words[0],
            email: email,
            role: role,
            reference: 'students/$id'))
        .whenComplete(() async {
      await addStudent(Student(
        id: id,
        imageUrl: _random.randomDp(name),
        facultyId: facultyId,
        degreeProgramId: degreeProgramId,
        about: about,
      ));
    });
  }

  Future<void> registerStaff(String id, String name, String email, String role,
      String department, String position, String accessLevel) async {
    List<String> words = _random.splitName(name);

    await addUser(UserM(
            id: id,
            name: name,
            displayName: words[0],
            email: email,
            role: role,
            reference: 'staff/$id'))
        .whenComplete(() async {
      await addStaff(Staff(id: id, department: department, position: position));
    });
  }

  Future<void> registerAdmin(String id, String name, String email, String role,
      String department, String accessLevel) async {
    List<String> words = _random.splitName(name);

    await addUser(UserM(
            id: id,
            name: name,
            displayName: words[0],
            email: email,
            role: role,
            reference: 'admin/$id'))
        .whenComplete(() async {
      await addAdmin(
          Admin(id: id, department: department, accessLevel: accessLevel));
    });
  }

  // Methods to add a data to Firestore
  Future<void> addUser(UserM user) async {
    await _fireStore.collection('users').doc(user.id).set(user.toFirestore());
  }

  Future<void> addAdmin(Admin admin) async {
    await _fireStore.collection('admin').doc(admin.id).set(admin.toFirestore());
  }

  Future<void> addStaff(Staff staff) async {
    await _fireStore.collection('staff').doc(staff.id).set(staff.toFirestore());
  }

  Future<void> addStudent(Student student) async {
    await _fireStore
        .collection('students')
        .doc(student.id)
        .set(student.toFirestore());
  }

  Future<void> addFaculty(Faculty faculty) async {
    await _fireStore
        .collection('faculty')
        .doc(faculty.id)
        .set(faculty.toFirestore());
  }

  Future<void> addDegreeProgram(DegreeProgram program) async {
    await _fireStore
        .collection('degreePrograms')
        .doc(program.id)
        .set(program.toFirestore());
  }

  Future<void> addLostItem(LostItem lostItem) async {
    await _fireStore
        .collection('lostItems')
        .doc(lostItem.id)
        .set(lostItem.toFirestore());
  }
  Future<void> addFoundItem(FoundItem foundItem) async {
    await _fireStore.collection('foundItems').doc(foundItem.id).set(foundItem.toFirestore());
  }


  // Method to retrieve a user from Firestore

  Future<UserM?> getUser(String userId) async {
    try {
      DocumentSnapshot doc =
          await _fireStore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
  Future<UserM?> getUserByEmail(String email) async {
    try {
      // Query the users collection for the document with the matching email
      QuerySnapshot querySnapshot = await _fireStore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Convert the first matching document to a User object
        return UserM.fromFirestore(
            querySnapshot.docs.first.data() as Map<String, dynamic>,
            querySnapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      print("Error fetching user by email: $e");
      return null;
    }
  }

  Future<Admin?> getAdmin(String adminId) async {
    try {
      DocumentSnapshot doc =
          await _fireStore.collection('admin').doc(adminId).get();
      if (doc.exists) {
        return Admin.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching admin: $e");
      return null;
    }
  }

  // Method to retrieve staff from Firestore
  Future<Staff?> getStaff(String staffId) async {
    try {
      DocumentSnapshot doc =
          await _fireStore.collection('staff').doc(staffId).get();
      if (doc.exists) {
        return Staff.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching staff: $e");
      return null;
    }
  }

  // Method to retrieve a student from Firestore
  Future<Student?> getStudent(String studentId) async {
    try {
      DocumentSnapshot doc =
          await _fireStore.collection('students').doc(studentId).get();
      if (doc.exists) {
        return Student.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching student: $e");
      return null;
    }
  }

  // Method to retrieve a faculty from Firestore
  Future<Faculty?> getFaculty(String facultyId) async {
    try {
      DocumentSnapshot doc =
          await _fireStore.collection('faculty').doc(facultyId).get();
      if (doc.exists) {
        return Faculty.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching faculty: $e");
      return null;
    }
  }

  // Method to retrieve a degree program from Firestore
  Future<DegreeProgram?> getDegreeProgram(String programId) async {
    try {
      DocumentSnapshot doc =
          await _fireStore.collection('degreePrograms').doc(programId).get();
      if (doc.exists) {
        return DegreeProgram.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching degree program: $e");
      return null;
    }
  }

  // Method to retrieve a lost item from Firestore
  Future<LostItem?> getLostItem(String lostItemId) async {
    try {
      DocumentSnapshot doc =
          await _fireStore.collection('lostItems').doc(lostItemId).get();
      if (doc.exists) {
        return LostItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching lost item: $e");
      return null;
    }
  }
  Future<FoundItem?> getFoundItem(String foundItemId) async {
    try {
      DocumentSnapshot doc = await _fireStore.collection('foundItems').doc(foundItemId).get();
      if (doc.exists) {
        return FoundItem.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching found item: $e");
      return null;
    }
  }
}
