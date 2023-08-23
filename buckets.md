# BucketsStore
this inits buckets  
have access to all buckets in the storage and can return a bucket by it's name  
can delete a bucket by it's name or add a new bucket

# StorageService
this have many things to do with storage and buckets (not only buckets)

# StorageBucketModel
create  
delete  
move  
rename  
and do some other things related to a storage bucket



# Workflow
create a storage bucket  
1. checks if the bucket already exists then return
1. if the bucket exists with a different path this will through an error

# Notes
checking for init to save a bucket id is only available through a bucket service  
so right now the user can't create a storage bucket by himself or calling the storage bucket model