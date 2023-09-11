# Server Side (Generating api keys)
## generating a new api key
1. create a new random api key from the name, createdAt, random String of 10 letters, expiry date if exist
```dart
String fullQuery = '$name|$apiKey|$createdAtString$expiryDateFinal';
```
2. decrypt this with the server global _encrypterSecretKey (This is the new api Key)  and it is public
3. check if any api was created with the same hash or not, if exist just repeat this process with another randomization of created at and random 10 letters string


## generating api secret key
1. using the generated api hash
2. random string of 20 letters
3. using base64 encryption to encrypt the api hash with the random 20 letters(Now we have the secret key)
4. encrypting the generated secret key with the global server _encrypterSecretKey, to save it on the database

## Send api key to frontend developer
1. send the api key and the api secret key to the app owner(frontend developer) through secure channels to use it in his app code.

# Client side (using the api key and secret key)
using hmac algorithm
1. getting the current server time from an api and generate the timestamp from this datetime
1. generating random id with the uuid library
1. generating the hmac with the api secret key from this string 'timestamp|api|id'
1. generate a json obj with the api, id, hmac, timestamp and convert it into json string
1. encrypt this json string with the api secret key and base64 encoding
1. with the previous encoded output i send it and the api key to the server in the headers with the  request to validation 

# Server Side (Front end request validation)
with the api key and the api hmac encoded output 

1. get the encrypted api secret key from the database using the apiKey
1. decrypt the secret key with the global server _encrypterSecretKey
1. use that api secret key to decrypt the hmac to read it's content (json file)
1. validate the hmac by recreating it and compare it with the hmac that the user sent  
1. validate the hmac in the json file and return the (api key date (apikey, createdAt)) if the hmac is valid, (null if the hmac is not valid)
1. making sure that the hmac was created from at least 2 seconds(it will be rejected if it is older than 2 seconds)
1. check if the api key is expired or deactivated from the database