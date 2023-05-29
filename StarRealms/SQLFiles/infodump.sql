USE starRealms;

-- counts the cards from each faction in the deck db
SELECT
    sum(case when faction_id = 1 then num_cards_in_deck else 0 end) AS BlobCount,
    sum(case when faction_id = 2 then num_cards_in_deck else 0 end) AS CultCount,
    sum(case when faction_id = 3 then num_cards_in_deck else 0 end) AS EmpireCount,
    sum(case when faction_id = 4 then num_cards_in_deck else 0 end) AS FederationCount
FROM card;

SELECT faction_id, name, num_cards_in_deck
FROM card
ORDER BY faction_id, name;