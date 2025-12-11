--------------------------------------------
-------------REGIONS TABLE------------------
--------------------------------------------

-- 1) Which region has the highest number of influencers?

DELIMITER $$
CREATE PROCEDURE GetTopRegionsByInfluencerCount(IN p_limit INT)
BEGIN
    SELECT r.region_name,
           COUNT(i.influencer_id) AS influencer_count
    FROM Regions_table r
    LEFT JOIN Influencers_table i ON i.region_id = r.region_id
    GROUP BY r.region_name
    ORDER BY influencer_count DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop PROCEDURE GetTopRegionsByInfluencerCount;
CALL GetTopRegionsByInfluencerCount(5);

-- 2)Which region produces the highest total ROI across campaigns?
DELIMITER $$

CREATE PROCEDURE GetTopRegionsByTotalROI(IN p_limit INT)
BEGIN
    SELECT r.region_name,
           ROUND(SUM(c.roi), 2) AS total_roi,
           COUNT(c.campaign_id) AS campaign_count
    FROM Regions_table r
    JOIN Influencers_table i ON i.region_id = r.region_id
    JOIN Campaigns_table c ON c.influencer_id = i.influencer_id
    GROUP BY r.region_name
    ORDER BY total_roi DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop PROCEDURE GetTopRegionsByTotalROI;
CALL GetTopRegionsByTotalROI(5);

-- 3) Which region receives the highest impressions and reach?
DELIMITER $$

CREATE PROCEDURE GetTopRegionsByImpressionsReach(IN p_limit INT)
BEGIN
    SELECT r.region_name,
           SUM(c.impressions) AS total_impressions,
           SUM(c.reach) AS total_reach
    FROM Regions_table r
    JOIN Influencers_table i ON i.region_id = r.region_id
    JOIN Campaigns_table c ON c.influencer_id = i.influencer_id
    GROUP BY r.region_name
    ORDER BY total_impressions DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop PROCEDURE GetTopRegionsByImpressionsReach;
CALL GetTopRegionsByImpressionsReach(5);

-- 4) What is the average engagement rate by region?
DELIMITER $$

CREATE PROCEDURE GetTopRegionsByAvgEngagement(IN p_limit INT)
BEGIN
    SELECT r.region_name,
           ROUND(AVG(c.engagement_rate), 2) AS avg_engagement_rate,
           COUNT(c.campaign_id) AS campaign_count
    FROM Regions_table r
    JOIN Influencers_table i ON i.region_id = r.region_id
    JOIN Campaigns_table c ON c.influencer_id = i.influencer_id
    WHERE c.engagement_rate IS NOT NULL
    GROUP BY r.region_name
    ORDER BY avg_engagement_rate DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop PROCEDURE GetTopRegionsByAvgEngagement;
CALL GetTopRegionsByAvgEngagement(5);

-- 5) Which region has the highest total conversions?
DELIMITER $$

CREATE PROCEDURE GetTopRegionsByConversions(IN p_limit INT)
BEGIN
    SELECT r.region_name,
           SUM(c.conversions) AS total_conversions
    FROM Regions_table r
    JOIN Influencers_table i ON i.region_id = r.region_id
    JOIN Campaigns_table c ON c.influencer_id = i.influencer_id
    GROUP BY r.region_name
    ORDER BY total_conversions DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop PROCEDURE GetTopRegionsByConversions;
CALL GetTopRegionsByConversions(5);
