------------------------------------------
-----------CAMPAIGNS TABLE----------------
------------------------------------------

-- 1) Which campaign types generate the highest ROI?

DELIMITER $$
CREATE PROCEDURE GetTopCampaignTypesByROI(IN p_limit INT)
BEGIN
    SELECT campaign_type,
           ROUND(AVG(roi), 2) AS avg_roi,
           COUNT(*) AS campaign_count
    FROM Campaigns_table
    GROUP BY campaign_type
    ORDER BY avg_roi DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop procedure GetTopCampaignTypesByROI;
CALL GetTopCampaignTypesByROI(5);

-- 2) What is the relationship between Budget and ROI?
DELIMITER $$

CREATE PROCEDURE GetBudgetBinsROI(IN p_limit INT)
BEGIN
    SELECT budget_range,
           ROUND(AVG(roi), 2) AS avg_roi,
           COUNT(*) AS campaign_count,
           ROUND(AVG(budget_usd), 2) AS avg_budget
    FROM (
        SELECT CASE
                 WHEN budget_usd < 5000 THEN 'Low (<5k)'
                 WHEN budget_usd BETWEEN 5000 AND 20000 THEN 'Medium (5k-20k)'
                 WHEN budget_usd BETWEEN 20001 AND 50000 THEN 'High (20k-50k)'
                 ELSE 'Very High (>50k)'
               END AS budget_range,
               budget_usd, roi
        FROM Campaigns_table
        WHERE budget_usd IS NOT NULL AND roi IS NOT NULL
    ) t
    GROUP BY budget_range
    ORDER BY avg_roi DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop procedure GetBudgetBinsROI;
CALL GetBudgetBinsROI(5);

-- 3) What is the top 5 highest-performing campaigns ranked by ROI?
DELIMITER $$

CREATE PROCEDURE GetTopCampaignsByROI(IN p_limit INT)
BEGIN
    SELECT campaign_id, roi, budget_usd, engagement_rate, click_through_rate, conversions
    FROM Campaigns_table
    WHERE roi IS NOT NULL
    ORDER BY roi DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop procedure GetTopCampaignsByROI;
CALL GetTopCampaignsByROI(5);

-- 4) Which campaigns have the highest engagement rate and CTR?
DELIMITER $$

CREATE PROCEDURE GetTopCampaignsByEngagementCTR(IN p_limit INT)
BEGIN
    SELECT campaign_id,
           engagement_rate,
           click_through_rate,
           ROUND(engagement_rate + click_through_rate, 2) AS engagement_click_through_rate_score,
           impressions,
           conversions,
           roi
    FROM Campaigns_table
    WHERE engagement_rate IS NOT NULL AND click_through_rate IS NOT NULL
    ORDER BY engagement_click_through_rate_score DESC
    LIMIT p_limit;
END$$
DELIMITER ;
drop procedure GetTopCampaignsByEngagementCTR;
CALL GetTopCampaignsByEngagementCTR(5);

-- 5) Which campaigns have negative ROI, and what similarities do they share?
DELIMITER $$

CREATE PROCEDURE GetWorstCampaignsByROI(IN p_limit INT)
BEGIN
    SELECT campaign_id, roi, budget_usd, campaign_type, engagement_rate, click_through_rate
    FROM Campaigns_table
    WHERE roi IS NOT NULL
    ORDER BY roi ASC
    LIMIT p_limit;
END$$
DELIMITER ;
drop procedure GetWorstCampaignsByROI;
CALL GetWorstCampaignsByROI(5);


