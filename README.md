# Building the container
``` 
docker build -t freeradius-psk . 
 ```

# Running the container

``` 
docker run -p 1812:1812 freeradius-psk:latest
 ```


# Configuring the EAP-PSK credentials
#### In the file (before building the container)
 * src/freeradius_mod_files/users: Add at the end the needed credentials as follows
``` 
 "user" AUTH-TYPE := EAP2, Cleartext-Password:="passwordpassword"
 ```
 
 # Configuring the clients that can access
#### In the file (before building the container)
  * src/freeradius_mod_files/clients.conf: Add at the end the network info from accepetd clients as follows
 ``` 
client 192.168.0.0/16 {
	secret		= testing123
	shortname	= private-network-2
}
``` 


