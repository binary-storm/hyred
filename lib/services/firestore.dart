import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final String uid;
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference listingCollection = Firestore.instance.collection('listings');

  FirestoreService({ this.uid });

  Future addListing(Map listing) async {
    listing["applicants"] = List<DocumentReference>();
    listing["user"] = userCollection.document(uid);
    listing["filledBy"] = "";
    listing["numberOfApplicants"] = 0;
    DocumentReference listingReference = await listingCollection.add(listing);
    DocumentSnapshot listingsSnapshot = await userCollection.document(uid).get();
    List<dynamic> listings = listingsSnapshot.data["listings"];
    print([listingReference, ...listings]);
    await userCollection.document(uid).updateData({
      "listings": [listingReference, ...listings]
    });
  }

  Future updateUserData(String fname, String lname, String background, String bio) async {
    return await userCollection.document(uid).setData({
      'registered': true,
      'fname': fname,
      'lname': lname,
      'background': background,
      'bio': bio
    });
  }

  Future registerBasicInformation(String fname, String lname, bool employer) async {
    List<DocumentReference> listings = [];
    return await userCollection.document(uid).updateData({
      'fname': fname,
      'lname': lname,
      'employer': employer,
      'listings': listings,
    });
  }

  Future registerAddress(String street, String apartment, String city, String province, String postal) async {
    return await userCollection.document(uid).updateData({
      'street': street,
      'apartment': apartment,
      'city': city,
      'province': province,
      'postal': postal
    });
  }

  Future registerBusinessName(String businessName) async {
    return await userCollection.document(uid).updateData({
      'businessName': businessName,
    });
  }

  Future getData() async {
    return await userCollection.document(uid).get();
  }

  Future onUserRegister() async {
    return await userCollection.document(uid).setData({
      'registered': false,
    });
  }

  Future onUserFinishRegister() async {
    return await userCollection.document(uid).updateData({
      'registered': true,
    });
  }

  Stream<DocumentSnapshot> get userData {
    return userCollection.document(uid).snapshots();
  }
}