import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_x/firebase/models/embeddings.dart';
import 'package:find_x/res/random.dart';
import '../res/read_date.dart';
import 'models/Faculty.dart';
import 'models/Student.dart';
import 'models/admin.dart';
import 'models/degree_program.dart';
import 'models/found_item.dart';
import 'models/image_m.dart';
import 'models/lost_found_unified.dart';
import 'models/lost_item.dart';
import 'models/notification_m.dart';
import 'models/staff.dart';
import 'models/user_m.dart';

//this changes for testing purposes //2025-03-01
class FireStoreService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Random _random = Random();
  ReadDate _readDate = ReadDate();

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
            name_lc: name.toLowerCase(),
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
  ) async {
    List<String> words = _random.splitName(name);

    await addUser(UserM(
            id: id,
            name: name,
            name_lc: name.toLowerCase(),
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
            name_lc: name.toLowerCase(),
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

  Future<void> addLostItem(LostItem lostItem, Embeddings vectors) async {
    DocumentReference docRef =
        await _fireStore.collection('lostItems').add(lostItem.toFirestore());
    lostItem.reference = 'embeddings/${docRef.id}';
    await _fireStore
        .collection('lostItems')
        .doc(docRef.id)
        .set(lostItem.toFirestore());
    // update the lostItem reference with embeddings
    await addVector(vectors, docRef.id);
    lostItem.id = docRef.id;
  }

  Future<void> addFoundItem(FoundItem foundItem, Embeddings vectors) async {
    DocumentReference docRef =
        await _fireStore.collection('foundItems').add(foundItem.toFirestore());
    foundItem.reference = 'embeddings/${docRef.id}';
    await _fireStore
        .collection('foundItems')
        .doc(docRef.id)
        .set(foundItem.toFirestore());
    // update the foundItem reference with embeddings
    await addVector(vectors, docRef.id);
    foundItem.id = docRef.id;
  }

  Future<void> addImage(ImageM imageM) async {
    await _fireStore.collection('images').add(imageM.toFirestore());
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

  Future<String?> getUserRole(String userId) async {
    try {
      // Retrieve the user document from the 'users' collection
      DocumentSnapshot doc =
          await _fireStore.collection('users').doc(userId).get();

      // Check if the document exists
      if (doc.exists) {
        // Extract the role from the document data
        return doc.get('role') as String?;
      } else {
        // Return null if the user document does not exist
        return null;
      }
    } catch (e) {
      // Print the error and return null in case of an exception
      print("Error fetching user role: $e");
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

  // Function to get the count of lost items
  Future<int> getLostItemsCount() async {
    try {
      // Query the lostItems collection
      QuerySnapshot querySnapshot =
          await _fireStore.collection('lostItems').get();
      return querySnapshot.docs.length;
    } catch (e) {
      print("Error getting lost items count: $e");
      return 0;
    }
  }

  // Function to get the count of found items
  Future<int> getFoundItemsCount() async {
    try {
      // Query the foundItems collection
      QuerySnapshot querySnapshot =
          await _fireStore.collection('foundItems').get();
      return querySnapshot.docs.length;
    } catch (e) {
      print("Error getting found items count: $e");
      return 0;
    }
  }

  //get Whole lost and found items count
  Future<Map<String, int>> getLostAndFoundItemsCount() async {
    try {
      int lostCount = await getLostItemsCount();
      int foundCount = await getFoundItemsCount();

      // Combine the counts
      return {
        'lostCount': lostCount,
        'foundCount': foundCount,
        'wholeCount': lostCount + foundCount
      };
    } catch (e) {
      print("Error getting lost and found items count: $e");
      return {'lostCount': 0, 'foundCount': 0, 'wholeCount': 0};
    }
  }

  //---
// Function to get today's lost items count
  Future<int> getTodayLostItemsCount() async {
    try {
      String today = _readDate.getDateNow(countLength: 3);
      print(today);
      QuerySnapshot querySnapshot = await _fireStore
          .collection('lostItems')
          .where('postedTime', isGreaterThanOrEqualTo: '$today/0/0')
          .get();

      print('${querySnapshot.docs.length}');

      final todayDocs = querySnapshot.docs.where((doc) {
        String postedTime = doc['postedTime'] as String;
        String postedDate = postedTime.split('/').sublist(0, 3).join('/');
        return postedDate == today;
      });

      return todayDocs.length;
    } catch (e) {
      print("Error getting today's lost items count: $e");
      return 0;
    }
  }

// Function to get today's found items count
  Future<int> getTodayFoundItemsCount() async {
    try {
      String today = _readDate.getDateNow(countLength: 3);
      QuerySnapshot querySnapshot = await _fireStore
          .collection('foundItems')
          .where('postedTime', isGreaterThanOrEqualTo: '$today/0/0')
          .get();

      // Additional filtering
      final todayDocs = querySnapshot.docs.where((doc) {
        String postedTime = doc['postedTime'] as String;
        String postedDate = postedTime.split('/').sublist(0, 3).join('/');
        return postedDate == today;
      });

      return todayDocs.length;
    } catch (e) {
      print("Error getting today's found items count: $e");
      return 0;
    }
  }

  // Function to get today's lost and found items count
  Future<Map<String, int>> getTodayLostAndFoundItemsCount() async {
    try {
      int lostCount = await getTodayLostItemsCount();
      int foundCount = await getTodayFoundItemsCount();

      // Combine the counts
      return {
        'lostCount': lostCount,
        'foundCount': foundCount,
        'wholeCount': lostCount + foundCount
      };
    } catch (e) {
      print("Error getting today's lost and found items count: $e");
      return {'lostCount': 0, 'foundCount': 0, 'wholeCount': 0};
    }
  }

//----

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

  // Method to retrieve lost and found items by userId
  Future<Map<String, List<dynamic>>> getLostAndFoundItemsById(
      String userId) async {
    try {
      QuerySnapshot lostItemsSnapshot = await _fireStore
          .collection('lostItems')
          .where('userId', isEqualTo: userId)
          .get();
      QuerySnapshot foundItemsSnapshot = await _fireStore
          .collection('foundItems')
          .where('userId', isEqualTo: userId)
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
      QuerySnapshot lostItemsSnapshot = await _fireStore
          .collection('lostItems')
          .orderBy('postedTime', descending: true)
          .limit(limit)
          .get();
      QuerySnapshot foundItemsSnapshot = await _fireStore
          .collection('foundItems')
          .orderBy('postedTime', descending: true)
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

  Future<List<dynamic>> getLostAndFoundItemsByIdWithLimit(
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

  // Function to search across users, lost items, and found items
  Future<Map<String, List<dynamic>>> searchAllCategories(String keyword) async {
    try {
      // Search users by name
      QuerySnapshot userSnapshot = await _fireStore
          .collection('users')
          .limit(30)
          .where('name_lc', isGreaterThanOrEqualTo: keyword)
          .where('name_lc', isLessThan: keyword + 'z')
          .get();

      List<UserM> users = userSnapshot.docs.map((doc) {
        return UserM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Search lost items by item name
      QuerySnapshot lostItemsSnapshot = await _fireStore
          .collection('lostItems')
          .limit(30)
          .where('itemName_lc', isGreaterThanOrEqualTo: keyword)
          .where('itemName_lc', isLessThan: keyword + 'z')
          .get();

      List<LostFoundUnified> lostItems = lostItemsSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return LostFoundUnified(
          id: doc.id,
          userId: data['userId'],
          userName: '', // Placeholder, will be filled later
          itemName: data['itemName'],
          description: data['description'],
          postedTime: data['postedTime'],
          isCompleted: data['isCompleted'],
          type: 'lost',
        );
      }).toList();

      // Search found items by item name
      QuerySnapshot foundItemsSnapshot = await _fireStore
          .collection('foundItems')
          .limit(30)
          .where('itemName_lc', isGreaterThanOrEqualTo: keyword)
          .where('itemName_lc', isLessThan: keyword + 'z')
          .get();

      List<LostFoundUnified> foundItems = foundItemsSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return LostFoundUnified(
          id: doc.id,
          userId: data['userId'],
          userName: '', // Placeholder, will be filled later
          itemName: data['itemName'],
          description: data['description'],
          postedTime: data['postedTime'],
          isCompleted: data['isCompleted'],
          type: 'found',
        );
      }).toList();

      // Combine lost and found items
      List<LostFoundUnified> allItems = [...lostItems, ...foundItems];

      // Get userIds from all items
      List<String> userIds =
          allItems.map((item) => item.userId).toSet().toList();

      // Initialize userNames list only if userIds is not empty
      List<String?> userNames =
          userIds.isNotEmpty ? List<String?>.filled(userIds.length, null) : [];

      if (userIds.isNotEmpty) {
        // Get usernames using userIds
        userNames = await getUserNamesByIds(userIds);
      }

      // Fill in usernames for lost and found items
      for (int i = 0; i < allItems.length; i++) {
        String? userName = userNames.isNotEmpty ? userNames[i] : 'Unknown';
        allItems[i].userName = userName ?? 'Unknown';
      }

      // Sort all items by postedTime in descending order
      allItems.sort((a, b) {
        DateTime dateA = _parseCustomDate(a.postedTime);
        DateTime dateB = _parseCustomDate(b.postedTime);
        return dateB.compareTo(dateA);
      });

      // Return results as a map
      return {
        'users': users,
        'items': allItems,
      };
    } catch (e) {
      print("Error searching all categories: $e");
      return {
        'users': [],
        'items': [],
      };
    }
  }

  // Function to write a notification to a user's subcollection
  Future<void> addNotification(
      String userId, NotificationM notification) async {
    try {
      // Use the Firestore auto-generated ID for the notification
      DocumentReference docRef = await _fireStore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add(notification.toFirestore());

      // Update the notification object with the generated ID
      notification.id = docRef.id;

      // Optionally, update the document with the ID if needed
      await docRef.update({'id': docRef.id});
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  // Function to read all notifications for a specific user
  Future<List<NotificationM>> getNotificationsById(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      return querySnapshot.docs.map((doc) {
        return NotificationM.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  // Function to delete a lost item by its ID
  Future<void> deleteLostItem(String lostItemId) async {
    try {
      await _fireStore.collection('lostItems').doc(lostItemId).delete();
      print("Lost item deleted successfully.");
    } catch (e) {
      print("Error deleting lost item: $e");
    }
  }

// Function to delete a found item by its ID
  Future<void> deleteFoundItem(String foundItemId) async {
    try {
      await _fireStore.collection('foundItems').doc(foundItemId).delete();
      print("Found item deleted successfully.");
    } catch (e) {
      print("Error deleting found item: $e");
    }
  }

  // Function to delete a notification by its ID
  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _fireStore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
      print("Notification deleted successfully.");
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  // Function to change user's status from pending to approved
  Future<void> approveUser(String userId) async {
    try {
      // Retrieve the user document to check current status
      DocumentSnapshot doc =
          await _fireStore.collection('users').doc(userId).get();

      if (doc.exists) {
        bool currentStatus = doc.get('isApproved') as bool;

        // Only update if the user is not already approved
        if (!currentStatus) {
          await _fireStore.collection('users').doc(userId).update({
            'isApproved': true,
          });
          print("User approved successfully.");
        } else {
          print("User is already approved.");
        }
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error approving user: $e");
    }
  }

// Function to set whether the user is restricted
  Future<void> setUserRestriction(String userId, bool isRestricted) async {
    try {
      // Update the user's document in the 'users' collection
      await _fireStore.collection('users').doc(userId).update({
        'isRestricted': isRestricted,
      });

      print("User restriction status updated successfully.");
    } catch (e) {
      print("Error updating user restriction status: $e");
    }
  }
  //____________________________________________________________________________

// Methods to add a vectors to Firestore
// this map contain {'0': textVector, '1': imageVector1, '2': imageVector2}
  Future<void> addVector(Embeddings embeddings, String id) async {
    await _fireStore
        .collection('embeddings')
        .doc(id)
        .set(embeddings.toFirestore());
  }

  // Helper method to parse the custom date format
  DateTime _parseCustomDate(String dateString) {
    List<int> dateParts = dateString.split('/').map(int.parse).toList();
    return DateTime(
        dateParts[0], dateParts[1], dateParts[2], dateParts[3], dateParts[4]);
  }
}
