-- Breeds Entity

-- get all breeds for the browse Breeds page, breeds.html
SELECT breed_id, name, activity_level, shedding_level, size
    FROM Breeds
    ORDER BY breed_id;

-- add a new breed, breeds_new.html page
INSERT INTO Breeds (name, activity_level, shedding_level, size)
    VALUES(:name_input, :activity_level_input, :shedding_level_input, :size_input);
-- return to breeds.html on save

-- delete a breed, breeds.html
DELETE from Breeds
    WHERE breed_id = :breed_id_ input;
-- return to breeds.html, refreshes page

--prepopulate update form with info from breeds, breeds_update.html
SELECT breed_id, name, activity_level, shedding_level, size
    FROM Breeds
    WHERE breed_id = :breed_id_input;

-- update a breed, breeds_update.html
UPDATE Breeds
    SET name = :name_input, activity_level = :activity_level_input,
        shedding_level = :shedding_level_input, size = :size_input
    WHERE breed_id = :breed_id_input;

-- Shelters Entity

-- get all shelters and their active dogs for the browse shelters page, shelters.html
SELECT Shelters.shelter_id, Shelters.name, Shelters.email, Shelters.street_address, 
    Shelters.city, Shelters.postal_code, Shelters.state, 
    IFNULL(shelter_dogs.active_dogs, 0) AS current_dogs
    FROM Shelters
    LEFT JOIN 
        (SELECT shelter_id, COUNT(dog_id) AS active_dogs
            FROM Dogs
            WHERE is_active = 1
            GROUP BY shelter_id) AS shelter_dogs 
    ON Shelters.shelter_id = shelter_dogs.shelter_id
    ORDER BY Shelters.shelter_id;

-- add a new shelter, shelters_new.html
INSERT INTO Shelters (name, email, street_address, city, postal_code, state)
    VALUES(:name_input, :email_input, :street_address_input, :city_input, :postal_code_input, :state_input);

-- we do not delete a shelter but instead set all its dogs to inactive, shelters.html
UPDATE Dogs
    SET is_active = 0
WHERE shelter_id = :shelter_id_input;

--prepopulate update form with info from shelters, shelters_update.html
SELECT shelter_id, name, email, street_address, city, postal_code, state
    FROM Shelters
    WHERE shelter_id = :shelter_id_input;

-- update a shelter, shelters_update.html
UPDATE Shelters
    SET name = :name_input, email = :email_input, street_address = :street_address_input,
        city = :city_input, postal_code = :postal_code_input, state = :state_input
    WHERE shelter_id = :shelter_id_input;

-- Dogs Entity

-- get all dogs for the browse dogs page, dogs.html
SELECT Dogs.dog_id, Dogs.name, Dogs.birthdate, Dogs.training_level, Dogs.is_family_friendly, Dogs.shelter_arrival_date, 
    Dogs.is_active, Shelters.name AS shelter_name, 
    IFNULL(Breeds.name, 'Mutt') AS breed
    FROM Dogs
    INNER JOIN Shelters ON Dogs.shelter_id = Shelters.shelter_id
    LEFT JOIN Breeds ON Dogs.breed_id = Breeds.breed_id
    ORDER BY is_active DESC, dog_id;

-- get all shelter IDs and Names to populate the shelter id input dropdown, dogs_new.html, dogs_update.html
SELECT shelter_id, name FROM Shelters
    ORDER BY name;

-- get all breed IDs and Names to populate the breed id input dropdown, dogs_new.html, dogs_update.html
SELECT breed_id, name FROM Breeds
    ORDER BY name;

-- add a new dog, dogs_new.html
INSERT INTO Dogs (name, birthdate, training_level, is_family_friendly, shelter_arrival_date, 
    is_active, shelter_id, breed_id)
    VALUES(:name_input, :birthdate_input, :training_level_input, :is_family_friendly_input, 
    :shelter_arrival_date_input, :is_active_input, :shelter_id_input, :breed_id_input);

-- we do not delete a dog but instead set it to inactive, dogs.html
-- we then set all its matches to inactive as well
UPDATE Dogs
    SET is_active = 0
WHERE dog_id = :dog_id_input;
UPDATE Matches
    SET is active = 0
WHERE dog_id = :dog_id_input;

--prepopulate update form with info from dogs, dogs_update.html
SELECT Dogs.name, Dogs.birthdate, Dogs.training_level, Dogs.is_family_friendly,
    Dogs.shelter_arrival_date, Dogs.is_active
    FROM Dogs
    WHERE dog_id = :dog_id_input;

-- update a dog, dogs_update.html
-- we do not allow updates to change the is_active attribute
-- meets criteria that we have 1 update function that can set a FK to NULL as breed_id can be set to NULL
UPDATE Dogs
    SET name = :name_input, birthdate = :birthdate_input, training_level = :training_level_input,
        is_family_friendly = :is_family_friendly_input, shelter_arrival_date = :shelter_arrival_date_input, 
        shelter_id = :shelter_id_input, breed_id = :breed_id_input
    WHERE dog_id = :dog_id_input;

-- Users Entity

-- Get all users for browse users page, users.html
SELECT * FROM Users
    ORDER BY is_active DESC, user_id;

-- Add a new user, users_new.html
INSERT INTO USERS (username, phone, email, birthdate, home_type, street_address, city, postal_code,
    state, activity_preference, shedding_preference, training_preference, size_preference, has_children,
    has_dog, has_cat, is_active)
    VALUES (:username_input, :phone_input, :email_input, :birthdate_input, :home_type_input,
    :street_address_input, :city_input, :postal_code_input, :state_input, :activity_preference_input,
    :shedding_preference_input, :training_preference_input, :size_preference_input, :has_children_input,
    :has_dog_input, :has_cat_input, :is_active_input);

-- we do not delete a user, we set them to inactive, users.html
-- we then set all their matches to inactive as well
UPDATE Users
    SET is_active = 0
WHERE user_id = :user_id_input;
UPDATE Matches
    SET is active = 0
WHERE user_id = :user_id_input;

-- Update a user, users_update.html
-- We do not allow updates to change the is_active attribute
UPDATE Users
    SET username = :username_input, phone = :phone_input, email = :email_input, birthdate = :birthdate_input,
        home_type = :home_type_input, street_address = :street_address_input, city = :city_input, 
        postal_code = :postal_code_input, state = :state_input, activity_preference = :activity_preference_input,
        shedding_preference = :shedding_preference_input, training_preference = :training_preference_input, 
        size_preference = :size_preference_input, has_children = :has_children_input, has_dog = :has_dog_input,
        has_cat = :has_cat_input
    WHERE user_id = :user_id_input;

-- Matches Entity

-- get all matches, matches.html
SELECT Matches.match_id, Matches.date, Matches.user_id, Users.username, Matches.dog_id, 
    Dogs.name as dog_name, Matches.is_active
    FROM Matches
    INNER JOIN Users ON Matches.user_id = Users.user_id
    INNER JOIN Dogs ON Matches.dog_id = Dogs.dog_id
    ORDER BY is_active desc, user_id, dog_id;

-- get all user IDs and usernames to populate the user id input dropdown, matches_new.html
SELECT user_id, username FROM Users
    ORDER BY user_id;

-- get all dog IDs and names to populate the dog id input dropdown, matches_new.html
SELECT dog_id, name FROM Dogs
    ORDER BY dog_id;

-- Add a new match, matches_new.html
INSERT INTO Matches (date, user_id, dog_id, is_active)
    VALUES (:date_input, :user_id_input, :dog_id_input, :is_active_input);

-- we do not update matches, no update function needed for matches

-- we do not delete matches, we set the Match to inactive, matches.html
UPDATE Matches 
    SET is_active = :is_active_input
WHERE match_id = :match_id_input

-- Adoptions Entity

-- Get all adoptions with usefull fields joined, adoptions.html
SELECT Adoptions.adoption_id, Adoptions.dog_id, Dogs.name AS dog_name,
    Adoptions.shelter_id, Shelters.name AS shelter_name, Adoptions.user_id,
    IFNULL(Users.username, 'Non-User') AS adopter, Adoptions.match_id,
    IFNULL(Matches.date, 'No Match') AS match_date, Adoptions.date AS adoption_date
    FROM Adoptions
    INNER JOIN Dogs ON Adoptions.dog_id = Dogs.dog_id
    INNER JOIN Shelters ON Adoptions.shelter_id = Shelters.shelter_id
    LEFT JOIN Users ON Adoptions.user_id = Users.user_id
    LEFT JOIN Matches ON Adoptions.match_id = Matches.match_id
    ORDER BY adoption_date DESC;

-- get all dog IDs, shelter IDs, dog names, and shelter names to populate the dog id input dropdown, adoptions_new.html, adoptions_update.html
-- the user will make one selection for both the dog_id and shelter_id by looking at the username and shelter name together
-- since each dog has one shelter, this input will then be sent to the database as seperate
-- user_id and match_id parameters in order to avoid selecting a dog with the same name from a different shelter just because 
--you did not check th dog id
SELECT Dogs.dog_id, Dogs.name, Shelters.shelter_id, Shelters.name AS shelter_name
    FROM Dogs
    INNER JOIN Shelters ON Dogs.shelter_id = Shelters.shelter_id
    WHERE Dogs.is_active = 1
    ORDER BY shelter_name;

-- get all match IDs, user IDs, and usernames to populate the user id input dropdown, adoptions_new.html, adoptions_update.html
-- the user will make one selection for both the match_id and user_id by looking at the username 
-- since each dog/user can only have one match, this input will then be sent to the database as seperate
-- user_id and match_id parameters
SELECT Matches.match_id, Matches.user_id, Users.username 
    FROM Matches
    INNER JOIN Users ON Matches.user_id = Users.user_id
    WHERE Matches.is_active = 1
    ORDER BY Users.username;

-- Add a new adoption, adoptions_new.html
-- The dog has now been adopted so we set it to inactive
-- Since the dog has been adopted, we also set its matches to inactive
INSERT INTO Adoptions (date, dog_id, shelter_id, user_id, match_id)
    VALUES (:date_input, :dog_id_input, :shelter_id_input, :user_id_input, :match_id_input);
UPDATE Dogs
    SET is_active = 0
Where dog_id = :dog_id_input;
UPDATE Matches
    SET is_active = 0
WHERE dog_id = :dog_id_input;

-- Delete an adoption, adoptions.html
-- This is like when a dog is returned, so we reactivate the dogs account and its matches
DELETE FROM Adoptions
    WHERE adoption_id = :adoption_id_input;
UPDATE Dogs
    SET is_active = 1
Where dog_id = :dog_id_input;
UPDATE Matches
    SET is_active = 1
WHERE dog_id = :dog_id_input;

-- There are two distinct kinds of updates that must be identified and handled seperately
-- Alternatively, we can disallow updates and use Delete and reenter instead

-- Update an adoption where the dog_id does not change, adoptions_update.html
UPDATE Adoptions
    SET date = :date_input, dog_id = :dog_id_input, shelter_id = :shelter_id_input,
    user_id = :user_id_input, match_id = :match_id_input;

-- Update an adoption where the dog_id does change, adoptions_update.html
-- We must now capture the original and new dog_ids as seperate parametes
-- We must reactivate the original dogs account and then deactivate the new dogs account
UPDATE Dogs
    SET is_active = 1
Where dog_id = :original_dog_id_input;
UPDATE Matches
    SET is_active = 1
WHERE dog_id = :original_dog_id_input;

UPDATE Adoptions
    SET date = :date_input, dog_id = :new_dog_id_input, shelter_id = :shelter_id_input,
    user_id = :user_id_input, match_id = :match_id_input;

UPDATE Dogs
    SET is_active = 0
Where dog_id = :new_dog_id_input;
UPDATE Matches
    SET is_active = 0
WHERE dog_id = :new_dog_id_input;

-- Dogs_has_users Entity

-- Get all 'likes' (M:M relationship rows) with usefull fields being joined for convenience, dogs_has_users.html
SELECT Dogs_has_users.dogs_has_users_id, Dogs_has_users.source,
    Dogs_has_users.dogs_dog_id, Dogs.name, Shelters.name,
    Dogs_has_users.users_user_id, Users.username
    FROM Dogs_has_users
    INNER JOIN Dogs ON Dogs_has_users.dogs_dog_id = Dogs.dog_id
    INNER JOIN Shelters ON Dogs.shelter_id = Shelters.shelter_id
    INNER JOIN Users ON Dogs_has_users.users_user_id = Users.user_id
    ORDER BY Dogs_has_users.dogs_has_users_id;

-- get all user IDs and usernames to populate the user id input dropdown, dogs_has_users_new.html
SELECT user_id, username FROM Users
    ORDER BY user_id;

-- get all dog IDs and names to populate the dog id input dropdown, dogs_has_users_new.html
SELECT dog_id, name FROM Dogs
    ORDER BY dog_id;

-- add a new "like", dogs_has_users_new.html
INSERT INTO Dogs_has_users (dogs_dog_id, users_user_id, source)
    VALUES (:dogs_dog_id_input, :users_user_id_input, :source_input);

--no update function is needed for 'likes'

-- delete a 'like', dogs_has_users.html
DELETE from Dogs_has_users
    WHERE dogs_has_users_id = :dogs_has_users_id_input;
-- return to dogs_has_users.html, refreshes page
