DROP DATABASE canasta;
CREATE DATABASE canasta;
USE canasta;

CREATE TABLE game_type(
	game_type_id INT PRIMARY KEY AUTO_INCREMENT,
    draw_number TINYINT DEFAULT 2 NOT NULL,
    discard_number TINYINT DEFAULT 1 NOT NULL,
    num_canastas_to_go_out TINYINT DEFAULT 2 NOT NULL,
    discard_piles TINYINT DEFAULT 1 NOT NULL,
    pickup_pile_from_canastas BOOL DEFAULT FALSE NOT NULL,
    wild_cards_in_meld BOOL DEFAULT FALSE NOT NULL,
    num_decks TINYINT DEFAULT 2 NOT NULL,
    bonus_value INT DEFAULT 100 NOT NULL,
    black_canasta_value INT DEFAULT 300 NOT NULL,
    red_canasta_value INT DEFAULT 500 NOT NULL,
    red_threes_for_doubling TINYINT DEFAULT 4 NOT NULL,
    meld_15_minimum INT DEFAULT (-5000) NOT NULL,
    meld_50_minimum INT DEFAULT (0) NOT NULL,
    meld_90_minimum INT DEFAULT 1500 NOT NULL,
    meld_120_minimum INT DEFAULT 3000 NOT NULL,
    score_to_win INT DEFAULT 5000 NOT NULL,
    deck_type ENUM('Standard', 'Value_on_card') DEFAULT 'Standard' NOT NULL
    );
    
INSERT INTO game_type()
VALUES ();

CREATE TABLE players (
    players_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
    nickname VARCHAR(50) DEFAULT 'no nickname :('
    );
    
INSERT INTO players (name, nickname)
VALUES ('Austin', 'Canasta Disasta');-- id 1
INSERT INTO players (name)
VALUES ('Katie');-- id 2
INSERT INTO players (name, nickname)
VALUES
	('Nicole',   'Canasta Masta'),-- id 3
    ('Ashleigh', 'Canasta Trasta');-- id 4
INSERT INTO players (name)
VALUES
	('Chuck'),-- id 5
    ('Carole'),-- id 6
    ('Jack');-- id 7

CREATE TABLE game(
	game_id INT PRIMARY KEY AUTO_INCREMENT,
    game_date DATE,
    which_game_on_day TINYINT,
    game_winner INT,
    FOREIGN KEY (game_winner) REFERENCES players(players_id),
    game_type_id INT DEFAULT 1,
    FOREIGN KEY (game_type_id) REFERENCES game_type(game_type_id)
);

INSERT INTO game(game_date, which_game_on_day, game_winner)
VALUES
	( (DATE '2022-11-20'), 1, 1),-- 1
    ( (DATE '2022-11-20'), 2, 2),-- 2
    ( (DATE '2022-11-20'), 3, 2),-- 3
    ( (DATE '2022-11-21'), 1, 1),-- 4
    ( (DATE '2022-11-21'), 2, 1),-- 5
    ( (DATE '2022-11-21'), 3, 2),-- 6
    ( (DATE '2022-11-22'), 1, 1),-- 7
    ( (DATE '2022-11-22'), 2, 2),-- 8
    ( (DATE '2022-11-25'), 1, 2),-- 9
    ( (DATE '2022-11-25'), 2, 1),-- 10
    ( (DATE '2022-11-26'), 1, 1);-- 11
    
CREATE TABLE hand_score(
	hand_score_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT,
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    hand_in_game INT
    );
 
 INSERT INTO hand_score(game_id, hand_in_game)
 VALUES
	(1,1),-- 1
    (1,2),-- 2
    (2,1),-- 3
    (2,2),-- 4
    (2,3),-- 5
    (3,1),-- 6
    (3,2),-- 7
    (4,1),-- 8
    (4,2),-- 9
    (5,1),-- 10
    (5,2),-- 11
    (5,3),-- 12
    (6,1),-- 13
    (6,2),-- 14
    (7,1),-- 15
    (7,2),-- 16
    (8,1),-- 17
    (8,2),-- 18
    (9,1),-- 19
    (9,2),-- 20
    (9,3),-- 21
    (10,1),-- 22
    (10,2),-- 23
    (11,1),-- 24
    (11,2);-- 25

CREATE TABLE player_hand_score(-- The hand score for a single player
	player_hand_score_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT,
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    players_id INT,
    FOREIGN KEY (players_id) REFERENCES players(players_id),
    hand_score_id INT,
    FOREIGN KEY (hand_score_id) REFERENCES hand_score(hand_score_id),
    earned_bonus BOOL DEFAULT FALSE,
    base_score INT DEFAULT 0,
    meld_score INT DEFAULT 0,
    went_out boolean DEFAULT FALSE
    );
    
INSERT INTO player_hand_score (game_id, players_id, hand_score_id, earned_bonus, base_score, meld_score, went_out)
VALUES
	(1,  1,  1,  0,  1100,   520, 0),
    (1,  2,  1,  0,     0,  -295, 0),
    (1,  1,  2,  0,  3200,   905, 1),
    (1,  2,  2,  0,     0,     0, 0),
    (2,  1,  3,  0,   800,    70, 0),
    (2,  2,  3,  1,  1400,   705, 1),
    (2,  1,  4,  0,  1000,   370, 0),
    (2,  2,  4,  0,  1900,   425, 0),
    (2,  1,  5,  0,  2000,   460, 1),
    (2,  2,  5,  0,   800,   335, 0),
    (3,  1,  6,  0,   200,   170, 0),
    (3,  2,  6,  0,  2000,   670, 1),
    (3,  1,  7,  0,     0,  -460, 0),
    (3,  2,  7,  0,  2300,   730, 1),
    (4,  1,  8,  0,  3000,   625, 1),
    (4,  2,  8,  0,   200,   270, 0),
    (4,  1,  9,  0,  2700,   635, 1),
    (4,  2,  9,  0,   500,   240, 0),
    (5,  1, 10,  0,   500,   455, 0),
    (5,  2, 10,  0,   200,   285, 0),
    (5,  1, 11,  0,  2900,   800, 1),
    (5,  2, 11,  0,   600,   255, 0),
    (5,  1, 12,  1,  2000,   670, 1),
    (5,  2, 12,  0,  1100,   260, 0),
    (6,  1, 13,  0,     0,  -485, 0),
    (6,  2, 13,  0,  3500,   825, 1),
    (6,  1, 14,  0,   500,   -25, 0),
    (6,  2, 14,  0,   800,   590, 0),
    (7,  1, 15,  0,  2100,   410, 0),
    (7,  2, 15,  0,   100,   320, 0),
    (7,  1, 16,  0,  3100,   730, 1),
    (7,  2, 16,  0,   100,   250, 0),
    (8,  1, 17,  0,   400,   250, 0),
    (8,  2, 17,  0,  3100,   675, 1),
    (8,  1, 18,  0,     0,  -490, 0),
    (8,  2, 18,  0,  1600,   570, 1),
    (9,  1, 19,  0,   200,    40, 0),
    (9,  2, 19,  0,  2200,   745, 1),
    (9,  1, 20,  0,  1300,   430, 1),
    (9,  2, 20,  0,   200,   -35, 0),
    (9,  1, 21,  0,   600,   210, 0),
    (9,  2, 21,  0,  2800,   630, 1),
    (10, 1, 22,  0,  2100,   760, 1),-- concealed
    (10, 2, 22,  1,   200,  -200, 0),
    (10, 1, 23,  0,  1700,   620, 1),
    (10, 2, 23,  0,     0,  -470, 0),
    (11, 1, 24,  0,  3100,   775, 0),
    (11, 2, 24,  0,   200,   355, 0),
    (11, 1, 25,  0,  2100,   445, 0),
    (11, 2, 25,  0,  1000,   435, 1);
    
CREATE TABLE deck_type(
	deck_type_id ENUM('Standard', 'Value_on_card') PRIMARY KEY 
);

CREATE TABLE card(
	card_id TINYINT PRIMARY KEY AUTO_INCREMENT,
	deck_type_id ENUM('Standard', 'Value_on_card') DEFAULT 'Standard' NOT NULL,
    FOREIGN KEY (deck_type_id) REFERENCES deck_type(deck_type_id),
    deck_number TINYINT NOT NULL,-- if there are mulitple decks, the 'number' of the deck, 1 for first deck etc
    suit ENUM('Clubs','Diamonds','Hearts','Spades','Joker') NOT NULL,
    color ENUM('Black','Red') NOT NULL,
    digit ENUM('A','2','3','4','5','6','7','8','9','10','Ja','Q','K','Jo') NOT NULL,
    card_value INT NOT NULL,
    isWild BOOL DEFAULT FALSE
    );
    


INSERT INTO deck_type (deck_type_id)
VALUES ('Standard'), ('Value_on_card');

INSERT INTO card (deck_number, suit, color, digit, card_value, isWild)
VALUES
	(1, 'Clubs',    'black', 'A',  20,  FALSE),
    (1, 'Clubs',    'black', '2',  20,  TRUE),
    (1, 'Clubs',    'black', '3',  5,   FALSE),
    (1, 'Clubs',    'black', '4',  5,   FALSE),
    (1, 'Clubs',    'black', '5',  5,   FALSE),
    (1, 'Clubs',    'black', '6',  5,   FALSE),
    (1, 'Clubs',    'black', '7',  5,   FALSE),
    (1, 'Clubs',    'black', '8',  10,  FALSE),
    (1, 'Clubs',    'black', '9',  10,  FALSE),
    (1, 'Clubs',    'black', '10', 10,  FALSE),
    (1, 'Clubs',    'black', 'Ja', 10,  FALSE),
    (1, 'Clubs',    'black', 'Q',  10,  FALSE),
    (1, 'Clubs',    'black', 'K',  10,  FALSE),
    (1, 'Diamonds', 'red',   'A',  20,  FALSE),
    (1, 'Diamonds', 'red',   '2',  20,  TRUE),
    (1, 'Diamonds', 'red',   '3',  100, FALSE),
    (1, 'Diamonds', 'red',   '4',  5,   FALSE),
    (1, 'Diamonds', 'red',   '5',  5,   FALSE),
    (1, 'Diamonds', 'red',   '6',  5,   FALSE),
    (1, 'Diamonds', 'red',   '7',  5,   FALSE),
    (1, 'Diamonds', 'red',   '8',  10,  FALSE),
    (1, 'Diamonds', 'red',   '9',  10,  FALSE),
    (1, 'Diamonds', 'red',   '10', 10,  FALSE),
    (1, 'Diamonds', 'red',   'Ja', 10,  FALSE),
    (1, 'Diamonds', 'red',   'Q',  10,  FALSE),
    (1, 'Diamonds', 'red',   'K',  10,  FALSE),
    (1, 'Hearts',   'red',   'A',  20,  FALSE),
    (1, 'Hearts',   'red',   '2',  20,  TRUE),
    (1, 'Hearts',   'red',   '3',  100, FALSE),
    (1, 'Hearts',   'red',   '4',  5,   FALSE),
    (1, 'Hearts',   'red',   '5',  5,   FALSE),
    (1, 'Hearts',   'red',   '6',  5,   FALSE),
    (1, 'Hearts',   'red',   '7',  5,   FALSE),
    (1, 'Hearts',   'red',   '8',  10,  FALSE),
    (1, 'Hearts',   'red',   '9',  10,  FALSE),
    (1, 'Hearts',   'red',   '10', 10,  FALSE),
    (1, 'Hearts',   'red',   'Ja', 10,  FALSE),
    (1, 'Hearts',   'red',   'Q',  10,  FALSE),
    (1, 'Hearts',   'red',   'K',  10,  FALSE),
    (1, 'Spades',   'black', 'A',  20,  FALSE),
    (1, 'Spades',   'black', '2',  20,  TRUE),
    (1, 'Spades',   'black', '3',  5,   FALSE),
    (1, 'Spades',   'black', '4',  5,   FALSE),
    (1, 'Spades',   'black', '5',  5,   FALSE),
    (1, 'Spades',   'black', '6',  5,   FALSE),
    (1, 'Spades',   'black', '7',  5,   FALSE),
    (1, 'Spades',   'black', '8',  10,  FALSE),
    (1, 'Spades',   'black', '9',  10,  FALSE),
    (1, 'Spades',   'black', '10', 10,  FALSE),
    (1, 'Spades',   'black', 'Ja', 10,  FALSE),
    (1, 'Spades',   'black', 'Q',  10,  FALSE),
    (1, 'Spades',   'black', 'K',  10,  FALSE),
    (1, 'Joker',    'black', 'Jo', 50,  TRUE),
    (1, 'Joker',    'red',   'Jo', 50,  TRUE),
    (2, 'Clubs',    'black', 'A',  20,  FALSE),
    (2, 'Clubs',    'black', '2',  20,  TRUE),
    (2, 'Clubs',    'black', '3',  5,   FALSE),
    (2, 'Clubs',    'black', '4',  5,   FALSE),
    (2, 'Clubs',    'black', '5',  5,   FALSE),
    (2, 'Clubs',    'black', '6',  5,   FALSE),
    (2, 'Clubs',    'black', '7',  5,   FALSE),
    (2, 'Clubs',    'black', '8',  10,  FALSE),
    (2, 'Clubs',    'black', '9',  10,  FALSE),
    (2, 'Clubs',    'black', '10', 10,  FALSE),
    (2, 'Clubs',    'black', 'Ja', 10,  FALSE),
    (2, 'Clubs',    'black', 'Q',  10,  FALSE),
    (2, 'Clubs',    'black', 'K',  10,  FALSE),
    (2, 'Diamonds', 'red',   'A',  20,  FALSE),
    (2, 'Diamonds', 'red',   '2',  20,  TRUE),
    (2, 'Diamonds', 'red',   '3',  100, FALSE),
    (2, 'Diamonds', 'red',   '4',  5,   FALSE),
    (2, 'Diamonds', 'red',   '5',  5,   FALSE),
    (2, 'Diamonds', 'red',   '6',  5,   FALSE),
    (2, 'Diamonds', 'red',   '7',  5,   FALSE),
    (2, 'Diamonds', 'red',   '8',  10,  FALSE),
    (2, 'Diamonds', 'red',   '9',  10,  FALSE),
    (2, 'Diamonds', 'red',   '10', 10,  FALSE),
    (2, 'Diamonds', 'red',   'Ja', 10,  FALSE),
    (2, 'Diamonds', 'red',   'Q',  10,  FALSE),
    (2, 'Diamonds', 'red',   'K',  10,  FALSE),
    (2, 'Hearts',   'red',   'A',  20,  FALSE),
    (2, 'Hearts',   'red',   '2',  20,  TRUE),
    (2, 'Hearts',   'red',   '3',  100, FALSE),
    (2, 'Hearts',   'red',   '4',  5,   FALSE),
    (2, 'Hearts',   'red',   '5',  5,   FALSE),
    (2, 'Hearts',   'red',   '6',  5,   FALSE),
    (2, 'Hearts',   'red',   '7',  5,   FALSE),
    (2, 'Hearts',   'red',   '8',  10,  FALSE),
    (2, 'Hearts',   'red',   '9',  10,  FALSE),
    (2, 'Hearts',   'red',   '10', 10,  FALSE),
    (2, 'Hearts',   'red',   'Ja', 10,  FALSE),
    (2, 'Hearts',   'red',   'Q',  10,  FALSE),
    (2, 'Hearts',   'red',   'K',  10,  FALSE),
    (2, 'Spades',   'black', 'A',  20,  FALSE),
    (2, 'Spades',   'black', '2',  20,  TRUE),
    (2, 'Spades',   'black', '3',  5,   FALSE),
    (2, 'Spades',   'black', '4',  5,   FALSE),
    (2, 'Spades',   'black', '5',  5,   FALSE),
    (2, 'Spades',   'black', '6',  5,   FALSE),
    (2, 'Spades',   'black', '7',  5,   FALSE),
    (2, 'Spades',   'black', '8',  10,  FALSE),
    (2, 'Spades',   'black', '9',  10,  FALSE),
    (2, 'Spades',   'black', '10', 10,  FALSE),
    (2, 'Spades',   'black', 'Ja', 10,  FALSE),
    (2, 'Spades',   'black', 'Q',  10,  FALSE),
    (2, 'Spades',   'black', 'K',  10,  FALSE),
    (2, 'Joker',    'black', 'Jo', 50,  TRUE),
    (2, 'Joker',    'red',   'Jo', 50,  TRUE);
    
DELIMITER //
CREATE PROCEDURE list_players_and_num_games_won()
BEGIN
SELECT COUNT(*) AS total_games,
       COUNT(if(game_winner=1,1,null)) AS Austin_games_won,
       COUNT(if(game_winner=2,1,null)) AS Katie_games_won
 FROM game;
 END //
 
 
-- CALL list_players_and_num_games_won();
CREATE PROCEDURE temp(IN _player_id INT, IN _hand_score_id INT, OUT num INT)
 BEGIN
 SELECT player_hand_score.base_score + player_hand_score.meld_score + if(player_hand_score.earned_bonus,100,0) INTO num
 FROM player_hand_score
 WHERE player_hand_score.players_id = _player_id AND player_hand_score.hand_score_id = _hand_score_id;
 END //
 
 
CREATE PROCEDURE list_hand_scores_desc()
BEGIN
SELECT players.name, player_hand_score.hand_score_id, canasta.handscore(players.players_id,player_hand_score.hand_score_id)
FROM players
RIGHT JOIN player_hand_score
ON players.players_id = player_hand_score.players_id
ORDER BY canasta.handscore(players.players_id,player_hand_score.hand_score_id) DESC;
END // 

DELIMITER //
CREATE FUNCTION canasta.helloWorld()
Returns VARCHAR(20)
DETERMINISTIC 
BEGIN
	RETURN 'HELLO WORLD';
END //

DELIMITER //
CREATE FUNCTION canasta.handscore(_player_id INT, _hand_score_id INT)
RETURNS int
DETERMINISTIC
BEGIN
    DECLARE result Int;
    SELECT player_hand_score.base_score + player_hand_score.meld_score + if(player_hand_score.earned_bonus,100,0) INTO result
    FROM player_hand_score
    WHERE player_hand_score.players_id = _player_id AND player_hand_score.hand_score_id = _hand_score_id;
    RETURN result;
END //

CREATE FUNCTION canasta.totalscore(_player_id INT)
RETURNS INT
DETERMINISTIC
BEGIN 
    DECLARE result INT;
    SELECT player_hand_score.base_score + player_hand_score.meld_score + player_hand_score.earned_bonus*100 INTO result
    FROM player_hand_score
    WHERE player_hand_score.players_id = _player_id;
    RETURN result;
END //

SELECT players.name, canasta.totalscore(players.player_id)
FROM players
-- RIGHT JOIN player_hand_score
ON players.players_id = player_hand_score.players_id
ORDER BY canasta.totalscore(players.player_id) DESC;

-- call list_hand_scores_desc();

Select SUM(player_hand_score.base_score) + SUM(player_hand_score.meld_score) + SUM(player_hand_score.earned_bonus*100) AS Austins_total_score
From player_hand_score
Where Player_hand_score.players_id = 1;

Select SUM(player_hand_score.base_score) + SUM(player_hand_score.meld_score) + SUM(player_hand_score.earned_bonus*100) AS Katies_total_score
From player_hand_score
Where Player_hand_score.players_id = 2;