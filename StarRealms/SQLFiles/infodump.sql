USE starRealms;

SELECT faction_id,
    count(*) AS total,
    sum(case when faction_id = 1 then 1 else 0 end) AS BlobCount,
    sum(case when faction_id = 2 then 1 else 0 end) AS CultCount,
    sum(case when faction_id = 3 then 1 else 0 end) AS EmpireCount,
    sum(case when faction_id = 4 then 1 else 0 end) AS FederationCount
FROM card
GROUP BY faction_Id
