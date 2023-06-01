
# <p align="center"> T-NSA-810 CIA </p>
  
## 🙇 Author

#### Kamil KHAN
- Email: [Write me ](mailto:kamil.khan@epitech.eu)

#### Patrick ARNAUD
- Email: [Write me ](mailto:partick.arnaud@epitech.eu)

#### Pierre Hung TSANG-TUNG
- Email: [Write me ](mailto:pierre-hung.tsang-tung@epitech.eu)


# <p align="center">HOW WE GOT FULL ACCESS TO THE INFRASTRUCTURE</p>

## What we know
The website is hosted by four VMs :

- The frontend
- The backend
- The database
- The monitoring 
   
Some credentials (login and password) without the corresponding platform
    
# <p align="center">Information we retrieved </p>
  
1. Try to log into the machine by combining the credential we have
2. Identify which host is hosting which service and what are they supposed to do

By doing these we found our first vulnerabilty.


# <p align="center">Root password</p>
  The root password on all vms are admin.  It is known that admin is amongst the most used passwords and can be crackable just using a brute force method.
## <p align="center">the fix</p>
we modified it to a sronger one 
we also use ssh to connect to the machines and we harden the protection of the machines by :

- we modified the ssh port to be a non standard one (2345)
- we installed fail2ban in order to ban ppl who try to connect to our server multiple times while they entered a wrong password 
- we restrain the ssh connection to be only via private key

we also noticed that the IPs wasn't static so we changed it :

| VMS | IP adresses| Accounts|
| -------- | -------- | -------- |
| Machine-1 (Front)    | 172.16.135.10  | root, admin,  soupeladmin, service-web|
| Machine-2  (db)       | 172.16.135.20| root, admin, service-web|
| Machine-3 (back)    |  172.16.135.30    | root, admin, service-web |
| Machine-4 (portainer)    | 172.16.135.40   | root, admin |


# <p align="center"> Fixing the front</p>
 
We saw that the API IP address was incorrect in the web application .env file, so we changed it to our static   IP.

# <p align="center">NEXUS SETUP</p>
  
We created our private docker registry on Nexus. Once we did that, we had to change the docker configuration on every host to ensure they had our repository in their configuration. We added, on each host, a /etc/docker/daemon.json in which we were declaring our repository's IP address and port. After a restart of the docker service, we had to make sure docker clients had access to the repository by using docker login with the appropriated rights.
    


# <p align="center">Conclusion</p>
  
Even if we were only 3 to work on this project. It was fun and challenging we aquired a lot of new skills and we're hope that this short description we'll be enough to convince you that we did a good work.
    
    
