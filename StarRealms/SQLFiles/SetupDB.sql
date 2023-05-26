/*show databases;*/
DROP DATABASE starRealms;
CREATE DATABASE starRealms;
USE starRealms;
/*SELECT DATABASE;*/


CREATE TABLE faction(
	faction_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    color VARCHAR(50)
    );
    
INSERT INTO faction(name, color)
VALUES
	('Blob','Green'),
    ('Machine Cult','Red'),
    ('Star Empire','Yellow'),
    ('Trade Federation','Blue');
    
CREATE TABLE card_type(
	card_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
    );
    
INSERT INTO card_type(name)
VALUES
	('Ship'),
    ('Base');
    
CREATE TABLE version(
	version_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
    );
    
INSERT INTO version(name)
VALUES
	('Original'),
    ('Colony Wars'),
    ('Frontiers'),
    ('Expansion Pack A'),
    ('Expansion Pack C'),
    ('Expansion Pack Red/Yellow');
    
-- Select * from version;

CREATE TABLE effect_type(
	effect_type_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(128)
    );

INSERT INTO effect_type(name)
VALUES
	('Damage'),
    ('Gold'),
    ('Authority'),
    ('Draw a card'),
    ('You may scrap a card in the trade row'),
    ('Destroy Target Base'),
    ('Acquire any ship for free and put it on top of your deck'),
    ('Draw a card for each Blob card you\'ve played this turn'),
    ('You may scrap a card in your hand or discard pile'),
    ('Copy another ship you\'ve played this turn'),
    ('Scrap a card in your hand or discard pile'),
    ('You may destroy target base'),
    ('Mech World counts as an ally for all factions'),
    ('Draw a card, then scrap a card in your hand'),
    ('Scrap up to two cards in your hand and/or discard pile, Draw a card for each card scrapped this way'),
    ('Target opponent discards a card'),
    ('Discard up to two cards, then draw that many cards'),
    ('Whenever you play a ship, gain one damage'),
    ('If you have two or more bases in play, draw two cards'),
    ('Put the next ship you acquire this turn on top of your deck');
    
    

CREATE TABLE effect(
	effect_id INT PRIMARY KEY, -- AUTO_INCREMENT,
    effect_type_id INT NOT NULL,
    FOREIGN KEY(effect_type_id) REFERENCES effect_type(effect_type_id),
    potency TINYINT,
	effect_type_id_2 INT, -- if there are secondary effects, may be null if there is no second effect
    FOREIGN KEY(effect_type_id) REFERENCES effect_type(effect_type_id),
    potency_2 TINYINT,
    relationship_between_effects ENUM('OR','BOTH','AND/OR') -- if there are two effects do we use one or both of them
);

CREATE TABLE ability_type(
	ability_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    faction_id INT, -- if the ability Type is ally ability, this tells the faction of the ally, will be null if not an ally ability
    primary_effect_id INT,-- effect of the primary ability
    FOREIGN KEY(primary_effect_id) REFERENCES effect(effect_id),
    ally_effect_id INT, -- the effect of the ally ability, may be null if no ally ability on card
    FOREIGN KEY(ally_effect_id) REFERENCES effect(effect_id),
    scrap_effect_id INT, -- the effect of the scrap ability, may be null if no scrap ability on card
    FOREIGN KEY(scrap_effect_id) REFERENCES effect(effect_id)
    );

CREATE TABLE card(
    card_id INT PRIMARY KEY AUTO_INCREMENT,
	cost TINYINT DEFAULT 0 NOT NULL,
    faction_id INT,
    FOREIGN KEY(faction_id) REFERENCES faction(faction_id),
    name VARCHAR(50) NOT NULL,
    card_type_id INT NOT NULL,
    FOREIGN KEY(card_type_id) REFERENCES card_type(card_type_id),
    ability_type_id INT NOT NULL,
    FOREIGN KEY(ability_type_id) REFERENCES ability_type(ability_type_id),
    version_id INT DEFAULT 1,
    FOREIGN KEY(version_id) REFERENCES version(version_id),
    num_cards_in_deck INT NOT NULL DEFAULT 1,
    flavor_text VARCHAR(128)
);

-- Select * from effect_type;

-- SHOW COLUMNS from effect;

INSERT INTO effect(effect_id, effect_type_id, potency, effect_type_id_2, potency_2, relationship_between_effects)
VALUES
	(1, 1, 1, NULL, NULL, NULL), -- 1 damage, Viper
    (2, 1, 2, NULL, NULL, NULL), -- 2 damage, Explorer srap effect
    (3, 1, 3, NULL, NULL, NULL), -- 3 damage, Blob fighter primary
    (4, 1, 4, NULL, NULL, NULL), -- 4 Damage
    (5, 1, 5, NULL, NULL, NULL), -- 5 Damage, Ram Primary
    (6, 1, 6, NULL, NULL, NULL), -- 6 Damage, Blob Destroyer Primary
    (7, 1, 7, NULL, NULL, NULL), -- 7 Damage
    (8, 1, 8, NULL, NULL, NULL), -- 8 Damage
    (9, 1, 9, NULL, NULL, NULL), -- 9 Damage
    (10, 1, 10, NULL, NULL, NULL), -- 10 Damage
    (11, 2, 1, NULL, NULL, NULL), -- Scout, one Gold
    (12, 2, 2, NULL, NULL, NULL), -- explorer, two gold
    (13, 2, 3, NULL, NULL, NULL), -- 3 gold, trade pod
    (14, 2, 4, NULL, NULL, NULL),
    (15, 2, 5, NULL, NULL, NULL),
    (16, 2, 6, NULL, NULL, NULL),
    (17, 2, 7, NULL, NULL, NULL),
    (18, 2, 8, NULL, NULL, NULL), -- 8 gold (unused?)
    (19, 3, 1, NULL, NULL, NULL), -- heal 1
    (20, 3, 2, NULL, NULL, NULL), -- heal 2
    (21, 3, 3, NULL, NULL, NULL), -- heal 3
    (22, 3, 4, NULL, NULL, NULL), -- heal 4
    (23, 3, 5, NULL, NULL, NULL), -- heal 5
    (24, 3, 6, NULL, NULL, NULL), -- heal 6
    (25, 3, 7, NULL, NULL, NULL), -- heal 7
    (26, 4, 1, NULL, NULL, NULL), -- Draw 1 card, Blob Fighter ally
    (27, 5, 1, 1, 4, 'BOTH'),-- You may scrap a card in trade row, and 4 damage, Battle Pod primary
    (28, 6, 1, 5, 1, 'AND/OR'),
    (29, 7, 1, NULL, NULL, NULL);


-- SHOW COLUMNS from ability_type;
-- select * from effect;

INSERT INTO ability_type(name, faction_id, primary_effect_id, ally_effect_id, scrap_effect_id)
VALUES
	('scout ability',         NULL, 11, NULL, NULL),
    ('viper ability',         NULL, 1,  NULL, NULL),
    ('explorer ability',      NULL, 12, NULL, 2),
    ('Blob Fighter ability',  1,    3,  26,   NULL),
    ('Battle Pod ability',    1,    27, 2,    NULL),
    ('Trade Pod ability',     1,    13, 2,    NULL),
    ('Ram ability',           1,    5,  2,    13),
    ('Blob Destroyer Ability',1,    6,  28,   NULL),
    ('Battle Blob Ability',   1,    8,  26,   4),
    ('Blob Carrier Ability',  1,    7,  29,   NULL);


INSERT INTO card(cost, faction_id, name, card_type_id, ability_type_id, version_id, num_cards_in_deck, flavor_text)
VALUES
	(0, NULL, 'Scout',          1, 1,  NULL, 8, NULL),
    (0, NULL, 'Viper',          1, 2,  NULL, 2, NULL),
    (2, NULL, 'Explorer',       1, 3,  NULL, 5, NULL),
    (1, 1,    'Blob Fighter',   1, 4,  1,    3, 'Either kill it before it signals the hive or run. There are other choices, but none you\'ll live through'),
    (2, 1,    'Battle Pod',     1, 5,  1,    2, NULL),
    (2, 1,    'Trade Pod',      1, 6,  1,    3, 'The loading and offloading process is efficient, but disgusting'),
    (3, 1,    'Ram',            1, 7,  1,    2, NULL),
    (4, 1,    'Blob Destroyer', 1, 8,  1,    2, 'When this monstrous ship shows up on a colony\'s sensors, they know the end is near...'),
    (6, 1,    'Battle Blob',    1, 9,  1,    1, NULL),
    (6, 1,    'Blob Carrier',   1, 10, 1,    1, '" Is that ... a whale?" - HMS Defender, final transmission');
    
    select * from effect_type;


-- SHOW COLUMNS FROM card;    
-- Select * from faction;