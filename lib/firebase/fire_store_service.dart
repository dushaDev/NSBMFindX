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
    String joinDate,
    String email,
    String contact,
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
            joinDate: joinDate,
            email: email,
            contact: contact,
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

  Future<void> registerStaff(
      String id,
      String name,
      String joinDate,
      String email,
      String contact,
      String role,
      bool isApproved,
      String department,
      String position,
      String accessLevel) async {
    List<String> words = _random.splitName(name);

    await addUser(UserM(
            id: id,
            name: name,
            displayName: words[0],
            joinDate: joinDate,
            email: email,
            contact: contact,
            role: role,
            reference: 'staff/$id',
            isApproved: isApproved))
        .whenComplete(() async {
      await addStaff(Staff(id: id, department: department, position: position));
    });
  }

  Future<void> registerAdmin(
      String id,
      String name,
      String joinDate,
      String email,
      String contact,
      String role,
      String department,
      String accessLevel) async {
    List<String> words = _random.splitName(name);

    await addUser(UserM(
            id: id,
            name: name,
            displayName: words[0],
            joinDate: joinDate,
            email: email,
            contact: contact,
            role: role,
            reference: 'admin/$id',
            isApproved: true))
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
    DocumentReference docRef =
        await _fireStore.collection('lostItems').add(lostItem.toFirestore());
    // update the lostItem object with the generated ID
    lostItem.id = docRef.id;
  }

  Future<void> addFoundItem(FoundItem foundItem) async {
    DocumentReference docRef =
        await _fireStore.collection('foundItems').add(foundItem.toFirestore());
    // update the foundItem object with the generated ID
    foundItem.id = docRef.id;
  }

  // Method to retrieve all users from FireStore
  Future<List<UserM>> getUsersAll() async {
    try {
      // Query the users collection to get all documents
      QuerySnapshot querySnapshot = await _fireStore.collection('users').get();

      // Convert the query results to a list of UserM objects
      return querySnapshot.docs.map((doc) {
        return UserM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  // Method to retrieve a user from FireStore
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

  // Method to retrieve a limited number of users from FireStore
  Future<List<UserM>> getUsersWithLimit(int limit) async {
    try {
      // Query the users collection to get a limited number of documents
      QuerySnapshot querySnapshot =
          await _fireStore.collection('users').limit(limit).get();

      // Convert the query results to a list of UserM objects
      return querySnapshot.docs.map((doc) {
        return UserM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
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

  Future<List<String?>> getUserNamesByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return [];

      // Get unique IDs for querying
      final uniqueIds = ids.toSet().toList();
      final Map<String, String> nameMap = {};

      // Process in batches of 10 (Firestore's whereIn limit)
      const batchSize = 10;
      for (var i = 0; i < uniqueIds.length; i += batchSize) {
        final batch = uniqueIds.sublist(
          i,
          i + batchSize > uniqueIds.length ? uniqueIds.length : i + batchSize,
        );

        final querySnapshot = await _fireStore
            .collection('users')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        // Map results
        for (var doc in querySnapshot.docs) {
          nameMap[doc.id] = doc.get('name') as String? ?? 'Anonymous';
        }
      }

      // Return names in original order with duplicates preserved
      return ids.map((id) => nameMap[id]).toList();
    } catch (e) {
      print("Error fetching usernames: $e");
      return List.filled(ids.length, null); // Return null for all on error
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
      DocumentSnapshot doc =
          await _fireStore.collection('foundItems').doc(foundItemId).get();
      if (doc.exists) {
        return FoundItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error fetching found item: $e");
      return null;
    }
  }

  // Method to retrieve all lost and found items sorted by date
  Future<Map<String, List<dynamic>>> getLostAndFoundItems() async {
    try {
      QuerySnapshot lostItemsSnapshot =
          await _fireStore.collection('lostItems').get();
      QuerySnapshot foundItemsSnapshot =
          await _fireStore.collection('foundItems').get();

      List<LostItem> lostItems = lostItemsSnapshot.docs.map((doc) {
        return LostItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      List<FoundItem> foundItems = foundItemsSnapshot.docs.map((doc) {
        return FoundItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Combine the lists and sort by postedTime
      List<dynamic> allItems = [...lostItems, ...foundItems];
      allItems.sort((a, b) {
        DateTime dateA = _parseCustomDate(a.postedTime);
        DateTime dateB = _parseCustomDate(b.postedTime);
        return dateB.compareTo(dateA); // Sort in descending order
      });
      //get userName using userId
      List<String?> userNames = [];
      List<String> userIds = [];

      for (var item in allItems) {
        userIds.add(item.userId);
      }
      userNames = await getUserNamesByIds(userIds);
      Map<String, List<dynamic>> allItemsMap = {
        'items': allItems,
        'userNames': userNames,
      };

      return allItemsMap;
    } catch (e) {
      print("Error fetching lost and found items: $e");
      return {
        'items': [],
        'userNames': [],
      };
    }
  }

  // Method to retrieve all lost and found items sorted by date with limit
  Future<List<dynamic>> getLostAndFoundItemsWithLimit(int limit) async {
    try {
      QuerySnapshot lostItemsSnapshot =
          await _fireStore.collection('lostItems').limit(limit).get();
      QuerySnapshot foundItemsSnapshot =
          await _fireStore.collection('foundItems').limit(limit).get();

      List<LostItem> lostItems = lostItemsSnapshot.docs.map((doc) {
        return LostItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      List<FoundItem> foundItems = foundItemsSnapshot.docs.map((doc) {
        return FoundItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Combine the lists and sort by postedTime
      List<dynamic> allItems = [...lostItems, ...foundItems];
      allItems.sort((a, b) {
        DateTime dateA = _parseCustomDate(a.postedTime);
        DateTime dateB = _parseCustomDate(b.postedTime);
        return dateB.compareTo(dateA); // Sort in descending order
      });

      return allItems;
    } catch (e) {
      print("Error fetching lost and found items: $e");
      return [];
    }
  }

  Future<List<dynamic>> getLostAndFoundItemsById(
      String userId, int limit) async {
    try {
      QuerySnapshot lostItemsSnapshot = await _fireStore
          .collection('lostItems')
          .where('userId', isEqualTo: userId)
          .limit(limit)
          .get();
      QuerySnapshot foundItemsSnapshot = await _fireStore
          .collection('foundItems')
          .where('userId', isEqualTo: userId)
          .limit(limit)
          .get();

      List<LostItem> lostItems = lostItemsSnapshot.docs.map((doc) {
        return LostItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      List<FoundItem> foundItems = foundItemsSnapshot.docs.map((doc) {
        return FoundItem.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Combine the lists and sort by postedTime
      List<dynamic> allItems = [...lostItems, ...foundItems];
      allItems.sort((a, b) {
        DateTime dateA = _parseCustomDate(a.postedTime);
        DateTime dateB = _parseCustomDate(b.postedTime);
        return dateB.compareTo(dateA); // Sort in descending order
      });

      return allItems;
    } catch (e) {
      print("Error fetching lost and found items: $e");
      return [];
    }
  }

  // Method to retrieve all users not approved
  Future<List<UserM>> getUsersNotApprovedWithLimit(int limit) async {
    try {
      // Query the users collection for documents where isApproved is false
      QuerySnapshot querySnapshot = await _fireStore
          .collection('users')
          .where('isApproved', isEqualTo: false)
          .limit(limit)
          .get();

      // Convert the query results to a list of User objects
      List<UserM> users = querySnapshot.docs.map((doc) {
        return UserM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return users;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  // Method to retrieve posted times from lost and found items. this use for the chart
  Future<Map<String, List<String>>> getPostedTimes() async {
    try {
      QuerySnapshot lostItemsSnapshot =
          await _fireStore.collection('lostItems').get();
      QuerySnapshot foundItemsSnapshot =
          await _fireStore.collection('foundItems').get();

      // Extract postedTime from lostItems
      List<String> lostItemsPostedTimes = lostItemsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['postedTime'] as String;
      }).toList();

      // Extract postedTime from foundItems
      List<String> foundItemsPostedTimes = foundItemsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['postedTime'] as String;
      }).toList();

      return {
        'lost': lostItemsPostedTimes,
        'found': foundItemsPostedTimes,
      };
    } catch (e) {
      print("Error fetching posted times: $e");
      return {
        'lost': [],
        'found': [],
      };
    }
  }

  // Helper method to parse the custom date format
  DateTime _parseCustomDate(String dateString) {
    List<int> dateParts = dateString.split('/').map(int.parse).toList();
    return DateTime(
        dateParts[0], dateParts[1], dateParts[2], dateParts[3], dateParts[4]);
  }
}
