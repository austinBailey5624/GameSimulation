/*show databases;*/
DROP DATABASE IF EXISTS starRealms;
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
	('Inflict [potency] Damage'),
    ('Gain [potency] Trade [AKA Gold]'),
    ('Heal [potency] Authority [AKA Health]'),
    ('Draw [potency] card[s]'),
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
    ('Put the next ship you acquire this turn on top of your deck'),
    ('You may put thie next ship you acquire this turn on top of your deck');
    
    

CREATE TABLE effect(
	effect_id INT PRIMARY KEY, -- AUTO_INCREMENT,
    effect_type_id INT NOT NULL,
    FOREIGN KEY(effect_type_id) REFERENCES effect_type(effect_type_id),
    potency TINYINT,
	effect_type_id_2 INT, -- if there are secondary effects, may be null if there is no second effect
    FOREIGN KEY(effect_type_id) REFERENCES effect_type(effect_type_id),
    potency_2 TINYINT,
    relationship_between_effects ENUM('OR','BOTH','AND/OR', 'ALL'), -- if there are two effects do we use one or both of them
    effect_type_id_3 INT, -- if there are tertiary effects, may be null
    potency_3 TINYINT 
);

CREATE TABLE ability_type(
	ability_type_id INT PRIMARY KEY, -- AUTO INCREMENT
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
    flavor_text VARCHAR(128),
    -- below are only valid for ship types
    health INT DEFAULT 0, 
    baseType ENUM('NOT A BASE', 'BASE', 'OUTPOST') DEFAULT 'NOT A BASE'
);

-- prepares effects with one or two effect types
INSERT INTO effect(effect_id, effect_type_id, potency, effect_type_id_2, potency_2, relationship_between_effects)
VALUES
	(1, 1,  1, NULL, NULL, NULL), -- 1 damage, Viper
    (2, 1,  2, NULL, NULL, NULL), -- 2 damage, Explorer srap effect
    (3, 1,  3, NULL, NULL, NULL), -- 3 damage, Blob fighter primary
    (4, 1,  4, NULL, NULL, NULL), -- 4 Damage
    (5, 1,  5, NULL, NULL, NULL), -- 5 Damage, Ram Primary
    (6, 1,  6, NULL, NULL, NULL), -- 6 Damage, Blob Destroyer Primary
    (7, 1,  7, NULL, NULL, NULL), -- 7 Damage
    (8, 1,  8, NULL, NULL, NULL), -- 8 Damage
    (9, 1,  9, NULL, NULL, NULL), -- 9 Damage
    (10, 1,  10, NULL, NULL, NULL), -- 10 Damage
    (11, 2,  1, NULL, NULL, NULL), -- Scout, one Gold
    (12, 2,  2, NULL, NULL, NULL), -- explorer, two gold
    (13, 2,  3, NULL, NULL, NULL), -- 3 gold, trade pod
    (14, 2,  4, NULL, NULL, NULL),
    (15, 2,  5, NULL, NULL, NULL),
    (16, 2,  6, NULL, NULL, NULL),
    (17, 2,  7, NULL, NULL, NULL),
    (18, 2,  8, NULL, NULL, NULL), -- 8 gold (unused?)
    (19, 3,  1, NULL, NULL, NULL), -- heal 1
    (20, 3,  2, NULL, NULL, NULL), -- heal 2
    (21, 3,  3, NULL, NULL, NULL), -- heal 3
    (22, 3,  4, NULL, NULL, NULL), -- heal 4
    (23, 3,  5, NULL, NULL, NULL), -- heal 5
    (24, 3,  6, NULL, NULL, NULL), -- heal 6
    (25, 3,  7, NULL, NULL, NULL), -- heal 7
    (26, 4,  1, NULL, NULL, NULL), -- Draw 1 card, Blob Fighter ally
    (27, 5,  1, 1,    4,    'BOTH'),-- You may scrap a card in trade row, and 4 damage, Battle Pod primary
    (28, 6,  1, 5,    1,    'AND/OR'),
    (29, 7,  1, NULL, NULL, NULL),
    (30, 1,  6, 4,    1,    'BOTH'),
    (31, 1,  5, 8,    1,    'OR'), -- Blob world primry effect
    (32, 2,  1, 9,    1,    'BOTH'), -- Trade Bot primary effect
    (33, 1,  2, 9,    1,    'BOTH'), -- Missle Bot Primary effect
    (34, 2,  2, 9,    1,    'BOTH'), -- Supply Bot Primary Effect
    (35, 10, 1, NULL, NULL, NULL), -- stealth needle copy
    (36, 2,  3, 1,    5,    'OR'), -- Patrol Mech primary effect
    (37, 11, 1, NULL, NULL, NULL), -- Patrol Mech secondary effect
    (38, 1,  4, 9,    1,    'BOTH'), -- Battle Mech primary effect
    (39, 1,  6, 12,   1,    'BOTH'), -- Missle Mech Primary effect
    (40, 13, 1, NULL, NULL, NULL), -- Mech World Primary Effect
    (41, 11, 1, NULL, NULL, NULL), -- Junkyard Primary Effect
    (42, 14, 1, NULL, NULL, NULL), -- Machine Base Primary Effect
    (43, 15, 1, NULL, NULL, NULL), -- Brain World Primary Effect
    (44, 1,  2, 16,   1,    'BOTH'), -- Imperial Fighter effect
    (45, 1,  1, 4,    1,    'BOTH'), -- Corvette effect
    (46, 2,  1, 4,    1,    'BOTH'), -- Survey Ship Primary effect
    (47, 16, 1, NULL, NULL, NULL), -- Target opponent discards a card
    (48, 1,  4, 16,   1,    'BOTH'), -- Imperial Frigate primary
    (49, 1,  4, 26,   1,    'BOTH'), -- Heavy cruiser primary
    (50, 1,  5, 26,   1,    'BOTH'), -- Battle cruiser Primary
    (51, 4,  1, 12,   1,    'BOTH'), -- Battle cruiser Scrap 
    (52, 1,  7, 4,    1,    'BOTH'), -- Dreadnaught primary
    (53, 2,  1, 17,   1,    'BOTH'), -- Recycling Station Primary
    (54, 18, 1, NULL, NULL, NULL),
    (55, 2,  2, 3,    4,    'BOTH'), -- Cutter primary
    (57, 2,  4, 10,   1,    'BOTH'), -- Freighter Primary
    (58, 3,  4, 1,    4,    'BOTH'), -- Trade escort primary
    (59, 1,  5, 26,   1,    'BOTH'), -- Flag ship primary
    (61, 6,  1, NULL, NULL, NULL), -- Destroy target base
    (62, 3,  1, 2,    1,    'OR'),  -- Trading Post
    (63, 3,  2, 2,    2,    'OR'),  -- Barter World
    (64, 3,  3, 1,    2,    'OR'),  -- Defense Center primary
    (65, 4,  1, 12,   1,    'BOTH'), -- port of call scrap
    (66, 2,  1, 21,   1,    'BOTH'); -- Central office Primary
    
-- prepares effects with three effect types
INSERT INTO effect(effect_id, effect_type_id, potency, effect_type_id_2, potency_2, relationship_between_effects, effect_type_id_3, potency_3)
VALUES
	(56, 3, 3, 2, 2, 'ALL', 19, 1), -- embassy yacht primary
    (60, 3, 4, 1, 5, 'ALL', 4,  2); -- Command Ship ability

INSERT INTO ability_type(ability_type_id, name, faction_id, primary_effect_id, ally_effect_id, scrap_effect_id)
VALUES
	(1,   'scout ability',              NULL, 11,   NULL, NULL),
    (2,   'viper ability',              NULL, 1,    NULL, NULL),
    (3,   'explorer ability',           NULL, 12,   NULL, 2),
    (4,   'Blob Fighter ability',       1,    3,    26,   NULL),
    (5,   'Battle Pod ability',         1,    27,   2,    NULL),
    (6,   'Trade Pod ability',          1,    13,   2,    NULL),
    (7,   'Ram ability',                1,    5,    2,    13),
    (8,   'Blob Destroyer Ability',     1,    6,    28,   NULL),
    (9,   'Battle Blob Ability',        1,    8,    26,   4),
    (10,  'Blob Carrier Ability',       1,    7,    29,   NULL),
    (11,  'MotherShip Ability',         1,    30,   26,   NULL),
    (12,  'Blob Wheel Ability',         1,    1,    NULL, 13),
    (13,  'The Hive Ability',           1,    3,    26,   NULL),
    (14,  'The Blob World Ability',     1,    31,   NULL, NULL),
    (15,  'Trade Bot Ability',          2,    32,   2,    NULL),
    (16,  'Missle Bot Ability',         2,    33,   2,    NULL),
    (17,  'Supply Bot Ability',         2,    34,   2,    NULL),
    (18,  'Stealth Needle Ability',     2,    35,   NULL, NULL),
    (19,  'Patrol Mech Ability',        2,    36,   37,   NULL),
    (20,  'Battle Mech Ability',        2,    38,   26,   NULL),
    (21,  'Missle Mech Ability',        2,    39,   26,   NULL),
    (22,  'Battle Station Ability',     2,    NULL, NULL, 5),
    (23,  'Mech World Ability',         2,    40,   NULL, NULL),
    (24,  'Junkyard Ability',           2,    41,   NULL, NULL),
    (25,  'Machine Base Ability',       2,    42,   NULL, NULL),
    (26,  'Brain World Ability',        2,    43,   NULL, NULL),
    (27,  'Imperial Fighter Ability',   3,    44,   2,    NULL),
    (28,  'Corvette Ability',           3,    45,   2,    NULL),
    (29,  'Survey Ship ability',        3,    46,   NULL, 47),
    (30,  'Imperial Frigate ability',   3,    48,   2,    26),
    (31,  'Heavy Cruiser ability',      3,    49,   26,   NULL),
    (32,  'Battle Cruiser ability',     3,    50,   47,   51),
    (33,  'Dreadnaught ability',        3,    52,   NULL, 5),
    (34,  'Space Station ability',      3,    2,    2,    14),
    (35,  'Recycling Station Abilty',   3,    53,   NULL, NULL),
    (36,  'War World ability',          3,    3,    4,    NULL),
    (37,  'Royal Redoubt ability',      3,    3,    47,   NULL),
    (38,  'Fleet HQ ability',           3,    54,   NULL, NULL),
    (39,  'Federation Shuttle ability', 4,    12,   22,   NULL),
    (40,  'Cutter ability',             4,    55,   4,    NULL),
    (41,  'Embassy Yacht ability',      4,    56,   NULL, NULL),
    (42,  'Freighter ability',          4,    57,   NULL, NULL),
    (43,  'Trade Escort ability',       4,    58,   26,   NULL),
    (44,  'Flagship ability',           4,    59,   23,   NULL),
    (45,  'Command Ship ability',       4,    60,   61,   NULL),
    (46,  'Trading Post ability',       4,    62,   NULL, 3),
    (47,  'Barter World ability',       4,    63,   NULL, 5),
    (48,  'Defense Center ability',     4,    64,   2,    NULL),
    (49,  'Port of Call ability',       4,    13,   NULL, 65),
    (50,  'Central office ability',     4,    66,   26,   NULL);
    


-- Inserts the Ships
INSERT INTO card(cost, faction_id, name, card_type_id, ability_type_id, version_id, num_cards_in_deck, flavor_text)
VALUES
	(0, NULL, 'Scout',               1, 1,  NULL, 8, NULL),
    (0, NULL, 'Viper',               1, 2,  NULL, 2, NULL),
    (2, NULL, 'Explorer',            1, 3,  NULL, 5, NULL),
    (1, 1,    'Blob Fighter',        1, 4,  1,    3, 'Either kill it before it signals the hive or run. There are other choices, but none you\'ll live through'),
    (2, 1,    'Battle Pod',          1, 5,  1,    2, NULL),
    (2, 1,    'Trade Pod',           1, 6,  1,    3, 'The loading and offloading process is efficient, but disgusting'),
    (3, 1,    'Ram',                 1, 7,  1,    2, NULL),
    (4, 1,    'Blob Destroyer',      1, 8,  1,    2, 'When this monstrous ship shows up on a colony\'s sensors, they know the end is near...'),
    (6, 1,    'Battle Blob',         1, 9,  1,    1, NULL),
    (6, 1,    'Blob Carrier',        1, 10, 1,    1, '" Is that ... a whale?" - HMS Defender, final transmission'),
    (7, 1,    'Mothership',          1, 11, 1,    1, NULL),
    (1, 2,    'Trade Bot',           1, 15, 1,    3, NULL),
    (2, 2,    'Missle Bot',          1, 16, 1,    3, NULL),
    (3, 2,    'Supply Bot',          1, 17, 1,    3, NULL),
    (4, 2,    'Stealth Needle',      1, 18, 1,    1, NULL),
    (4, 2,    'Patrol Mech',         1, 19, 1,    2, 'With the Blobs an ever present danger, even the Cult\'s cargo carrying mechs bristle with firepower'),
    (5, 2,    'Battle Mech',         1, 20, 1,    1, NULL),
    (6, 2,    'Missle Mech',         1, 21, 1,    1, NULL),
    (1, 3,    'Imperial Fighter',    1, 27, 1,    3, NULL),
    (2, 3,    'Corvette',            1, 28, 1,    2, NULL),
    (3, 3,    'Survey Ship',         1, 29, 1,    3, NULL),
    (3, 3,    'Imperial Frigate',    1, 30, 1,    3, NULL),
 --   (5, 3,    'Heavy Cruiser',       1, 31, 1,    1, NULL), -- Taking out for now because he is part of the next expansion (colony wars, added in error)
    (6, 3,    'Battlecruiser',       1, 32, 1,    1, NULL),
    (7, 3,    'Dreadnaught',         1, 33, 1,    1, NULL),
    (1, 4,    'Federation Shuttle',  1, 39, 1,    3, '"Fast? This baby doesn\'t just haul cargo, she hauls..."'),
    (2, 4,    'Cutter',              1, 40, 1,    3, '"Built for cargo, armed for conflict. Versatitlity for an unpredictable universe. \n - Premier Aerospace Cargo Enterprises'),
    (3, 4,    'Embassy Yacht',       1, 41, 1,    2, '"War should always be a last resort. It\'s bad for the bottom line"'),
    (4, 4,    'Freighter',           1, 42, 1,    2, '"This class of mammoth cargo shits is one of the keys to the Federation\'s vast trade-based wealth"'),
    (5, 4,    'Trade Escort',        1, 43, 1,    1, '"The heavily armored Escort class was the Federation\'s first response to the Blob threat."'),
    (6, 4,    'Flagship',            1, 44, 1,    1, NULL),
    (8, 4,    'Command Ship',        1, 45, 1,    1, NULL);
    
-- Inserts the Bases
INSERT INTO card(cost, faction_id, name, card_type_id, ability_type_id, version_id, num_cards_in_deck, health, basetype, flavor_text)
VALUES
    (3, 1, 'Blob Wheel',          2, 12, 1, 3, 5, 'BASE',    NULL),
    (5, 1, 'The Hive',            2, 13, 1, 1, 5, 'BASE',    NULL),
    (8, 1, 'Blob World',          2, 14, 1, 1, 7, 'BASE',    NULL),
    (3, 2, 'Battle Station',      2, 22, 1, 2, 5, 'OUTPOST', 'A Battle Station fusion core can double as a devestating weapon... once.'),
    (5, 2, 'Mech World',          2, 23, 1, 1, 6, 'OUTPOST', 'This man-made planet is a galactic center for open source tech'),
    (6, 2, 'Junkyard',            2, 24, 1, 1, 5, 'OUTPOST', 'The Machine Cult\'s first commandment: "Thou shalt not waste tech."'),
    (7, 2, 'Machine Base',        2, 25, 1, 1, 6, 'OUTPOST', 'This high-tech city is like a beehive: it looks chaotic but vital work is being done efficiently at a frenetic pace.'),
    (8, 2, 'Brain World',         2, 26, 1, 1, 6, 'OUTPOST', 'The Machine Cult build these supercomputing space station sto run every aspect of their society. Now they worship them as gods.'),
    (4, 3, 'Space Station',       2, 34, 1, 2, 4, 'OUTPOST', NULL),
    (4, 3, 'Recycling Station',   2, 35, 1, 2, 4, 'OUTPOST', NULL),
    (5, 3, 'War World',           2, 36, 1, 1, 4, 'OUTPOST', NULL),
    (6, 3, 'Royal Redoubt',       2, 37, 1, 1, 6, 'OUTPOST', NULL),
    (8, 3, 'Fleet HQ',            2, 38, 1, 1, 8, 'BASE',    NULL),
    (3, 4, 'Trading Post',        2, 46, 1, 2, 4, 'OUTPOST', NULL),
    (4, 4, 'Barter World',        2, 47, 1, 2, 4, 'BASE',    NULL),
    (5, 4, 'Defense Center',      2, 48, 1, 1, 5, 'OUTPOST', NULL),
    (6, 4, 'Port of Call',        2, 49, 1, 1, 6, 'OUTPOST', NULL),
    (7, 4, 'Central Office',      2, 50, 1, 1, 6, 'BASE',    NULL);
    



-- SHOW COLUMNS FROM card;    
-- Select * from faction;