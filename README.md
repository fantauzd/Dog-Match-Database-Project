Project Outline and Database Outline: 
We are still awaiting feedback for step 2. However, we identified some issues during normalization and made the following changes:
We added a shelter name as an attribute to the shelters entity. This is relevant information we should capture.
We removed the max holding time and kill shelter attributes from the shelters entity. We have decided to no longer display results based on the remaining lifespan of the dog, as this makes the application more dark and may lead to less users
We added an is_active attribute to the users and dogs entity. This will be changed when a user or dog deletes their account so that we can retain their information while stopping that information from continuing to be displayed.
We added a separate primary key for the dogs_has_users entity. This should make queries more efficient.
We added a source attribute to the dogs_has_users interchange table to track who initiated the “like” and ensure that users and dogs do not see dogs or users that they have already liked.
We replaced the location attribute with street_address, postal_code, city, and state attributes in the users and shelters entity. We now plan to use an API to geocode locations as needed.
We changed the phone attribute in the users entity to a varchar(255) data type to meet best practices for storing phone numbers.

Overview
The state of Idaho currently has just over 3000 dogs in its animal shelters. Adopters often struggle to find the best dog for their living situation, and dogs that need a forever home are often adopted and returned. More concerning, shelter capacity is at an all time high while adoption rates have decreased by 12% from pandemic levels. Our database driven website will bring new attention to dogs in Idaho animal shelters and create matches with owners that can meet their needs. 
The success of apps like Tinder and Bumble demonstrate the ability for quick matchmaking sites to increase visibility and lead to meaningful relationships. Why not build a similar site for dogs in need? Our website will provide an interface for the 20,000 potential dog owners in the state of Idaho to learn about pets that are up for adoption. It will provide details about each dog and its needs so that users can make informed decisions before bringing home a new family-member.
Users will create a profile. Each user profile stores the user's preferences and info in the users table. Users will swipe through the profiles of adoptable dogs. While swiping, users will be presented with relevant info about each dog using data stored in the dogs table and the breeds table. Based on this information, users can “like” specific dogs as they swipe. This “like” will be stored in the dogs_has_users table. Once a dog is “liked”, the shelter currently holding the dog will receive the details of the matched user. If an animal shelter worker reciprocates the “like” on behalf of the dog, then this will also be stored in the dogs_has_users table and a match will be created and stored in the matches table. If the shelter approves of the match, they can choose to follow up with the user and begin the adoption process. If the dog is adopted, whether by a user or outside party, then the adoption event is recorded and the dog is removed from the dogs table. This provides shelters with more options for their dogs, so dogs that receive many matches can go to the best homes for their specific needs.

Database Outline
This section will detail the entities, attributes, and relationships between entities of the the projects database
Users: records the details of users who are looking for a dog to adopt. These details will be used by shelter workers to “like” users based on behalf of the dog and its needs. We capture information about users that will help animal workers make the best decision for the dog. For example, the training_preference represents how willing a user is to spend time training their dog, on a scale of 1 to 10. This corresponds with the training_level attribute in the dogs entity, which measures how much training a dog needs from 1 to 10. This is an object entity.
user_id: INT, unique, auto increment, not NULL, PK
username: VARCHAR(225), not NULL
phone: VARCHAR(255), not NULL
email: VARCHAR(225), not NULL
birthdate: DATE
street_address: VARCHAR(255), not NULL
city: VARCHAR(255), not NULL
postal_code: VARCHAR(255), not NULL
state: VARCHAR(255), not NULL
activity_preference: SMALLINT(10)
shedding_preference: SMALLINT(10)
training_preference: SMALLINT(10)
size_preference: VARCHAR(45), (“Small, “Medium”, “Large”)
has_children: TINYINT(1)
has_dog: TINYINT(1)
has_cat: TINYINT(1)
is_active: TINYINT(1), not NULL
Relationships: 
M:M between users and dogs is implemented with an interchange table using dog_id from dogs and user_id from users. This stores the “likes” between dogs and users. When a like is made, we will check to see if the corresponding like has been made. If so, this will create a row in the match entity. This is the beginning of the adoption process.
1:M between adoptions and users implemented with user_id being a foreign key in adoptions. This is used to store certain information about adoptions users do. We want to be able to track how many adoptions the app is responsible for. This could also be used to flag users making too many adoptions.
1:M between matches and users implemented with user_id being a foreign key in matches. This is used to store information about when a dog and user match for adoption. This could be used to create a matches page that shows a user all of their matches. Storing when matches are created allows us to see metrics on matches and the time between matches and adoption. We can use this to limit the number of matches for a user, so they do not waste animal shelter worker’s time.

Dogs: records details of dogs waiting to be adopted. This is an object entity.
dog_id: INT, unique, auto increment, not NULL, PK
name: VARCHAR(255), not NULL
birthdate: DATE
training_level: SMALLINT(10)
is_family_friendly: TINYINT(1)
shelter_arrival_date: DATE
is_active: TINYINT(1), not NULL
shelter_id: INT, FK, not NULL
breed_id: INT, FK, not NULL
Relationships: 
M: M between dogs and users is implemented with an interchange table using dog_id from dogs and user_id from users. This stores the “likes” between dogs and users. When a like is made, we will check to see if the corresponding like has been made. If so, this will create a row in the match entity. This is the beginning of the adoption process.
1: M between dogs and breeds implemented with breed_id being a FK inside dogs. This is used to store certain breed characteristics that users may be interested in. We want to present users with details about the dog that allow them to make good choices. Some of these characteristics are applicable to the breed, allowing the animal shelter worker to save time when creating a dog entry in the dog entity.
1: M between shelter and dogs implemented with shelter_id being a foreign key inside dogs. Each dog must be at a shelter. This allows us to track the number of adoptions by shelter and allows us to show customers dogs that are near their location, as each shelter has a location. Furthermore, we can track the number of days the dog has been at a shelter and the max holding time that shelter allows to prioritize showing dogs that have little time left. This may be a challenge to implement and saved for a personal project add on.
1: 1 relationship between dogs and adoptions implemented with dog_id from dogs being a foreign key in adoptions. Each adoption must have one dog. New adoptions will trigger a delete operation in the dogs table as that dog is no longer available for adoption.
1:M between dogs and matches implemented with dog_id as a foreign key in matches. Each match must have one dog. This allows shelter workers to view matches on behalf of a dog and proceed with the best given match(es).
Dog_has_users: Is an interchange table that facilitates the M:M relationship between dogs and users. It has the dog_id and user_id as foreign keys. This table is used to store “likes” between dogs and users. When reciprocated, “likes” generate a match and send a push notification to the shelter to begin the adoption process. The source attribute is set to either ‘dog’ or ‘user’ to track when likes are reciprocated (when we have both sources)
dogs_has_users_id: INT, unique, auto increment, not NULL, PK
dogs_dog_id: INT, not NULL
users_user_id: INT, not NULL
source: varchar(45), not NULL
Breeds: records and describes characteristics of different breeds of dogs. This is an object entity.
breed_id: INT, unique, auto increment, not NULL, PK
name: VARCHAR(255), not NULL
activity_level: SMALLINT(10)
shedding_level: SMALLINT(10)
size: VARCHAR(45)
Relationships: 
1:M relationship between breeds and dogs implemented with breed_id being a foreign key in dogs. This is used to store certain breed characteristics that users may be interested in. We want to present users with details about the dog that allow them to make good choices. Some of these characteristics are applicable to the breed, allowing the animal shelter worker to save time when creating a dog entry in the dog entity.
Shelters: records information about adoption shelters. This is an object entity.
shelter_id:  INT, unique, auto increment, not NULL, PK
name: VARCHAR(255), not NULL
email: VARCHAR(255), not NULL
street_address: VARCHAR(255), not NULL
city: VARCHAR(255), not NULL
postal_code: VARCHAR(255), not NULL
state: VARCHAR(255), not NULL
Relationships: 
1:M relationship with dogs implemented by using shelter_id and a foreign key in dogs. his allows us to track the number of adoptions by shelter and allows us to show customers dogs that are near their location, as each shelter has a location. Furthermore, we can track the number of days the dog has been at a shelter and the max holding time that shelter allows to prioritize showing dogs that have little time left. This may be a challenge to implement and saved for a personal project add on.
1:M between shelter and adoptions implemented with shelter_id as a foreign key in adoptions. Each adoption must have come from one animal shelter. This allows for easy summations of adoptions by animal shelters. We can see which shelters are using the app successfully.
Adoptions: records information about the adoptions of dogs. Adoptions may stem from outside the website and hence a match and user is not required for an adoption. When adoptions are created, the dog is no longer shown to users. This is an event entity.
adoption_id:  int, unique, auto increment, not NULL, PK
date: DATE
shelter_id: INT, FK, not NULL
dog_id: INT, FK, not NULL
user_id: INT, FK
match_id: INT, FK
Relationships: 
1:M between shelter and adoptions implemented with a shelter_id as a foreign key in adoptions. Each adoption must have come from one animal shelter. This allows for easy summations of adoptions by animal shelters. We can see which shelters are using the app successfully.
1:M between adoptions and users implemented with user_id as a foreign key in adoptions. This is used to store certain information about adoptions users do. We want to be able to track how many adoptions the app is responsible for. This could also be used to flag users making too many adoptions.
1:1 between adoptions and matches with match_id as a foreign key in adoptions. This allows us to tell which adoptions came from matches and judge the success of the application. This gives us a good performance metric.
1:1 between adoptions and dogs with dog_id as a foreign key in adoptions. Each adoption must have one dog. New adoptions will trigger a delete operation in the dogs table as that dog is no longer available for adoption.
Matches: records information about matches between users and dogs. Together, with the adoptions table, this table can be used to generate metrics about dog adoption and success rates. When matches are created, notifications can be sent to the appropriate animal shelter so that they can begin the adoption process. This is an event entity.
match_id: INT, unique, auto increment, not NULL, PK
date: DATE, not NULL
user_id: INT, FK, not NULL
dog_id: INT, FK, not NULL
Relationships: 
1:M between dogs and matches implemented with dog_id as a foreign key in matches. Each match must have one dog. This allows shelter workers to view matches on behalf of a dog and proceed with the best given match(es).
1:M between users and matches implemented with user_id as foreign key in matches. This is used to store information about when a dog and user match for adoption. This could be used to create a matches page that shows a user all of their matches. Storing when matches are created allows us to see metrics on matches and the time between matches and adoption. We can use this to limit the number of matches for a user, so they do not waste animal shelter worker’s time. For example, we don’t want a user to have 100 active matches.
1:1 between adoptions and matches with match_id as a foreign key in adoptions. This allows us to tell which adoptions came from matches and judge the success of the application. This gives us a good performance metric.


