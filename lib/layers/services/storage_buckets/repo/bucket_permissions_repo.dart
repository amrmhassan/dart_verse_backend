//! bucket can only contain other buckets or files
//! so no thing called createSubFolder inside a bucket
//! you can only upload a file to a bucket and play with that file, no folders can be created inside a bucket except those folders who are buckets
import 'package:dart_verse_backend/layers/services/storage_buckets/models/storage_bucket_model.dart';

class BucketPermissionsRepo {
  late StorageBucket bucket;
  // each bucket will have 4 default permissions (write, read, delete, editPermissions) and will be stored in .acm binary file
  // each bucket .acm file will contain sub files permissions or sub files .acm files
  // -- for example bucket called amr with some files profilePic, personalPic
  // amr wants his bucket to be public and everyone with link can download or view any content from the bucket
  // but for the file personalPic amr want only him to view his personalPic
  // so in the bucket .acm file it will contain some kind of list for sub files permissions
  // the .acm file will be a json like object on the form of
  var acm = {
    'permissions': [
      //  permission read have * in his allowed list, this means anyone can read this bucket
      {
        'name': 'read',
        'allowed': ['*']
      },
      //  permission write have *only 2 users ids in his allowed list, this means only these 2 users can write to this bucket
      {
        'name': 'write',
        'allowed': ['user_id1', 'user_id2']
      },
      //  permission delete have no one in his allowed list, this means no one can delete from this bucket
      {'name': 'read', 'allowed': []},
    ],
    'sub_permissions': [
      // this will have the file sub path inside the bucket, so it's abs path will be bucket_path+'/'+sub_path
      {
        'sub_path': 'sub path of the file inside the bucket itself',
        'permissions': [
          //  permission read have * in his allowed list, this means anyone can read this bucket
          {
            'name': 'read',
            'allowed': ['*']
          },
          //  permission write have *only 2 users ids in his allowed list, this means only these 2 users can write to this bucket
          {
            'name': 'write',
            'allowed': ['user_id1', 'user_id2']
          },
          //  permission delete have no one in his allowed list, this means no one can delete from this bucket
          {'name': 'read', 'allowed': []},
        ]
      },
    ],
  };
}
