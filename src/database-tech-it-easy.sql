DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS televisions_wall_brackets;
DROP TABLE IF EXISTS remote_controllers CASCADE;
DROP TABLE IF EXISTS televisions;
DROP TABLE IF EXISTS cimodules;
DROP TABLE IF EXISTS wall_brackets;

-- users tabel.
CREATE TABLE users (
    username varchar(50),
    password varchar(255),
    -- het verschil tussen "text" en "varchar" is dat je van varchar de lengte kan limiteren en van text niet.
    email text
);



-- wallbracket tabel
CREATE TABLE wall_brackets (
    id serial PRIMARY KEY,
    name varchar(255),
    size text,
    price double precision NOT NULL,
    adjustable boolean NOT NULL,
    brand text
);

-- CI_modules tabel
CREATE TABLE cimodules (
	-- Hier staat PRIMARY KEY bij het id zelf vermeld. Dit mag ook op het einde. Het resultaat is hetzelfde.
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(255) NOT NULL UNIQUE,
    type varchar(255) NOT NULL UNIQUE,
    price double precision NOT NULL
);



CREATE TABLE remote_controllers (
    id serial PRIMARY KEY,
    name varchar(255),
    brand varchar(255), 
    price double precision, 
    available int DEFAULT 0,
    sold int,
    compatible_with varchar(255),
    battery_type varchar (255),
    television_id int
	
);

-- televisions tabel
CREATE TABLE televisions (
    id serial PRIMARY KEY,
    name varchar(255) NOT NULL,
    brand varchar(255), 
    type varchar(255) NOT NULL UNIQUE,
    price double precision, 
    available int DEFAULT 0,
    sold int,
    refresh_rate double precision,
    screen_type varchar(255),
    remote_id int,
	ci_module_id int,
    CONSTRAINT fk_remotecontroller FOREIGN KEY (remote_id) REFERENCES remote_controllers(id),
    CONSTRAINT fk_cimodule FOREIGN KEY (ci_module_id) REFERENCES cimodules(id)
);


--  televisions_wall_brackets tabel MANY TO MANY relatie
CREATE TABLE televisions_wall_brackets(
    television_id int,
    wall_bracket_id int,
    CONSTRAINT fk_television FOREIGN KEY (television_id) REFERENCES televisions(id),
    CONSTRAINT fk_wallbracket FOREIGN KEY (wall_bracket_id) REFERENCES wall_brackets(id)
);

-- maakt id zelf aan
INSERT INTO televisions(name, brand, type, price, available, sold, refresh_rate, screen_type)
    VALUES  ('Oled', 'Samsung', 'Xph45', 112, 23, 12, 60, 'XL'  ),
            ('Happy', 'Samsung', 'ffg12', 100, 25, 12, 60, 'Medium');
            
INSERT INTO remote_controllers (compatible_with, name, brand, price, sold, battery_type, television_id)
VALUES 	('Oled', 'Afstands1', 'Samsung',  11, 26, 'aaa', (SELECT televisions.id FROM televisions WHERE name ='Oled')),
		('Happy', 'Afstands2', 'Philips',  9, 11, 'AA', (SELECT televisions.id FROM televisions WHERE name = 'Happy' )),
		('Oled', 'Afstands3', 'Nikkei', 9, 11, 'AA', (SELECT televisions.id FROM televisions WHERE name = 'Oled' ));       


INSERT INTO wall_brackets (id, name, size, adjustable, brand, price)
VALUES (1, 'LG small', '25X32', false, 'LG bracket', 32.23),
       (2, 'LG big', '25X32/32X40', true, 'LG bracket', 32.23),
       (3, 'Philips small', '25X25', false, 'Philips bracket', 32.23),
       (4, 'Nikkei big', '25X32/32X40', true, 'Nikkei bracket', 32.23),
       (5, 'Nikkei small', '25X32', false, 'Nikkei bracket', 32.23);

INSERT INTO televisions_wall_brackets(television_id, wall_bracket_id) values (1, 5);
INSERT INTO televisions_wall_brackets(television_id, wall_bracket_id) values (2, 4);
INSERT INTO televisions_wall_brackets(television_id, wall_bracket_id) values (1, 3);
INSERT INTO televisions_wall_brackets(television_id, wall_bracket_id) values (2, 2);
		
			
-- SELECT * FROM televisions 
-- JOIN remote_controllers ON televisions.id = remote_controllers.television_id;

-- SELECT * FROM televisions_wall_brackets;

-- TV en wallbracket 
	SELECT televisions.id AS television_id, televisions.name AS television_name, wall_brackets.id AS wall_bracket_id, wall_brackets.name AS wall_bracket_name
	FROM televisions_wall_brackets
	JOIN televisions ON televisions.id = televisions_wall_brackets.television_id
	JOIN wall_brackets ON wall_brackets.id = televisions_wall_brackets.wall_bracket_id;
	
-- TV en remote_controller relatie 

	SELECT televisions.id, televisions.name as tv_name, remote_controllers.name as remote_name
	FROM televisions
	JOIN remote_controllers ON televisions.name = remote_controllers.compatible_with;




