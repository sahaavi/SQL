-- https://platform.stratascratch.com/coding/10187-find-the-total-number-of-available-beds-per-hosts-nationality?code_type=3

select nationality, sum(n_beds) as total_av_beds
from airbnb_apartments ap
JOIN airbnb_hosts ah on ap.host_id = ah.host_id
GROUP by nationality
order by total_av_beds desc;