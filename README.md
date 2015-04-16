# Dollhouse
Keep in touch with your girlfriends and all their gossip with this delightful iOS chat app written in Swift that uses Parse.

### Data Model
In order to support multiple users chatting across multiple rooms the following data model will be used. 

| Room         |
| ------------- |
| user1      |
| user2      |
A Room table will contain the users in that Room.

A Room can also contain many user messages which is supported in the Message table.

| Message         |
| ------------- |
| content      |
| room      |
| user      |
The Message table will contain the content of each Message and which Room (foreign key) and user (foreign key) the Message belongs to.

This model supports multiple users in a Room as well as multiple Messages per user per Room.

### Support or Contact
Visit [ddApps.co](http://ddapps.co) to see more.
