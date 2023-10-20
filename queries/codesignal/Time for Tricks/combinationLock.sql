SELECT
  ROUND(POWER(10, SUM(LOG10(LENGTH(characters))))) AS combinations
FROM discs;
