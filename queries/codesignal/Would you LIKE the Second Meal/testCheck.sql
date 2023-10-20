SELECT id, 
    IF (
        given_answer = correct_answer , "correct", 
        IF (given_answer IS NULL, "no answer", "incorrect") 
    ) AS checks
FROM answers
ORDER BY id;