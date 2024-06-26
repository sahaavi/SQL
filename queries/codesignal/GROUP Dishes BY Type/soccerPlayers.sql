SELECT GROUP_CONCAT(
    first_name, ' ', surname, ' ', '#', player_number 
    ORDER BY player_number ASC 
    SEPARATOR '; '
) AS players
FROM soccer_team;