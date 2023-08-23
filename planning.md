about the storage service
i need to add a way of securing the files or the whole folder
not every folder is a bucket but every bucket is a folder
a bucket can have files or folders inside
a bucket will have a file called acm and it's a sql db file which keep track of permissions for the bucket itself or it's children
every file or folder inside a bucket have a ref which is it's relative path from it's nearest parent bucket

buckets can contain each other but in this way the child bucket has nothing to do with the parent bucket
so if we have 2 buckets (parent and child) buckets and the parent bucket prevent all users from using it's children 
but the child bucket allow all users 
so if a file inside the child bucket will be allowed to all users
we just allow buckets to contain each others just to make it easy for us to make sub buckets
for example i want to create a bucket for my backend server for users and allow all users to use this bucket files
but i want to create a sub folder called users
inside this folder i want to add users buckets and each user bucket is only accessible through that user
-- for this to work 
each bucket model should have (bucket name, bucket parent folder path)
for sub bucket it should have (name, parent folder path)

so if i need to create a parent bucket called admin
inside it i want to have 2 folders (users, public)
inside the users i want to create a sub buckets for user1, user2
to refer the user1 bucket i will need to make this ref = 'admin/users/user1'
## the only new thing here is for a non-bucket dir or for a file to get it's permissions i just need to get the nearest bucket and look for it's children permissions

## so buckets are only there to manage permissions
and they can be refered with normal refs just like normal folders
so for the public folder ref='admin/public' then put a file or delete or do whatever you want but ofcourse check for it's nearest bucket permissions to do so

Wrapping up (Steps):
1- fix the permission system to use sql db and create 2 files inside a bucket called acm child-acm
2- secure all operations on buckets with acm file
3- secure all operations on sub-files of sub-dirs with child-acm
4- if sub-dir is a bucket use the sub-bucket permissions to deal with it