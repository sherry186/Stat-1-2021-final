-- 1-a
select class_member.member_id, 
       avg(submission_count) as submission_avg, 
       count(challenge_id) as HW_submitted 
  from class_member 
  left join(
	select account_id, challenge_id, count(*) as submission_count from class_member
	 inner join submission on submission.account_id = class_member.member_id 
	 inner join problem on problem.id = submission.problem_id
	 inner join challenge on challenge.id = problem.challenge_id and challenge.class_id = 21 and challenge.title similar to 'PD108-1 HW(5|6|7|8|9|10)'
	 where class_member.class_id = 21 and class_member.role = 'NORMAL'
	 group by account_id, challenge_id
	 order by account_id
  ) as submission_stat on class_member.member_id = submission_stat.account_id
  where class_member.class_id = 21 and class_member.role = 'NORMAL'
 group by class_member.member_id
 order by class_member.member_id;
 
 -- 1-b
  SELECT class_member.member_id AS account_id,
         submission.id AS submission_id,
         challenge.id AS challenge_id,
         challenge.title AS challenge_title,
         judgment.verdict AS verdict
    FROM class_member
   INNER JOIN submission ON submission.account_id = class_member.member_id 
   INNER JOIN judgment ON judgment.submission_id = submission.id
   INNER JOIN problem ON problem.id = submission.problem_id 
   INNER JOIN challenge ON challenge.id = problem.challenge_id AND challenge.class_id = 25 AND challenge.title LIKE '%HW%'
   WHERE class_member.class_id = 25
   ORDER BY account_id, challenge_id, submission_id;
   
-- 2
 SELECT account_id, submission.id AS submission_id, submit_time FROM submission 
  INNER JOIN class_member ON class_member.member_id = submission.account_id AND class_member.class_id = 25
  INNER JOIN problem ON problem.id = submission.problem_id 
  INNER JOIN challenge ON challenge.id = problem.challenge_id AND challenge.class_id = 25 AND challenge.title LIKE '%HW%'
  INNER JOIN judgment ON judgment.submission_id  = submission.id
  ORDER BY submit_time DESC;

 -- 3-a
 SELECT account_id, 
	    submission.id AS submission_id,
	    problem_id, 
	    challenge.id AS challenge_id,
		challenge.title AS challenge_title,
	    submit_time, 
	    start_time AS challenge_start, 
	    end_time AS challenge_end 
   FROM class_member 
  INNER JOIN submission ON submission.account_id = class_member.member_id
  INNER JOIN problem ON problem.id = submission.problem_id
  INNER JOIN challenge ON challenge.id = problem.challenge_id AND challenge.class_id = 25 AND challenge.title LIKE '%HW%'
  WHERE class_member.class_id = 25;
  
  
 -- 3-b
SELECT DISTINCT ON (account_id, problem_id)
	   account_id, 
	   submission.id AS submission_id,
	   challenge.id AS challenge_id,
	   challenge.title AS challenge_title,
	   problem_id, 
	   submit_time, 
	   start_time AS challenge_start, 
	   end_time AS challenge_end 
  FROM class_member 
 INNER JOIN submission ON submission.account_id = class_member.member_id
 INNER JOIN problem ON problem.id = submission.problem_id
 INNER JOIN challenge ON challenge.id = problem.challenge_id AND challenge.class_id = 25 AND challenge.title LIKE '%HW%'
 WHERE class_member.class_id = 25 
 ORDER BY account_id ASC, problem_id ASC, submission.id ASC;
 
 
 -- 4-a
SELECT class_member.member_id, old_exam_record.submission_id FROM class_member
  LEFT JOIN(
	SELECT DISTINCT ON (account_id) account_id, submission.problem_id, submission.id AS submission_id FROM class_member
	 INNER JOIN submission ON submission.account_id = class_member.member_id 
	        AND submission.problem_id between 578 AND 581
	 WHERE class_member.class_id = 25
  ) AS old_exam_record ON class_member.member_id = old_exam_record.account_id 
 WHERE class_id = 25
 ORDER BY member_id ASC;
 
 -- 4-b
SELECT account_id, SUM(score) FROM (
	SELECT DISTINCT ON (account_id, problem_id) submission.account_id AS account_id, judgment.score AS score FROM submission
	 INNER JOIN (
		SELECT DISTINCT ON (account_id) account_id FROM class_member
	     INNER JOIN submission ON submission.account_id = class_member.member_id 
	    	    AND submission.problem_id between 578 AND 581
	     WHERE class_member.class_id = 25
	 ) AS written_account ON submission.account_id = written_account.account_id
	 INNER JOIN problem ON problem.id = submission.problem_id AND submission.problem_id between 740 AND 743
	 INNER JOIN judgment ON judgment.submission_id = submission.id
	 ORDER BY account_id, problem_id
 ) AS account_judgment
 GROUP BY account_judgment.account_id;