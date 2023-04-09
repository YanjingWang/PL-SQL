DROP VIEW GKDW.MTM_SURVEY_CONNECTED_C_V;

/* Formatted on 29/01/2021 11:23:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.MTM_SURVEY_CONNECTED_C_V
(
   DIM_YEAR,
   DIM_MONTH_NUM,
   COUNTRY,
   COURSE_PL,
   COURSE_MOD,
   ROOT_COURSE_CODE,
   COURSE_CODE,
   SHORT_NAME,
   EVENT_ID,
   FACILITY_REGION_METRO,
   CONNECTED_FLAG,
   CONNECTED_V_TO_C,
   END_DATE,
   INSTRUCTOR,
   EVAL_SUBMITTED_ID,
   QUESTION,
   QUESTION_ID,
   QUESTION_CATEGORY,
   ANSWER,
   ANSWER_TYPE
)
AS
   SELECT   DISTINCT
            TD.DIM_YEAR,
            TD.DIM_MONTH_NUM,
            ED.COUNTRY,
            CD.COURSE_PL,
            CD.COURSE_MOD,
            SUBSTR (CD.COURSE_CODE, 1, 4) root_course_code,
            CD.COURSE_CODE,
            CD.SHORT_NAME,
            ED.EVENT_ID,
            ED.FACILITY_REGION_METRO,
            CASE
               WHEN CD.COURSE_MOD = 'C-LEARNING'
               THEN
                  CASE
                     WHEN ED.CONNECTED_C = 'Y' THEN 'Connected_C'
                     ELSE 'Non_Connected_C'
                  END
               WHEN CD.COURSE_MOD = 'V-LEARNING'
               THEN
                  CASE
                     WHEN ED.CONNECTED_V_TO_C IS NOT NULL THEN 'Connected_V'
                     ELSE 'Non_Connected_V'
                  END
               ELSE
                  'NA'
            END
               Connected_Flag,
            ED.CONNECTED_V_TO_C,
            ED.END_DATE,
            IE.LASTNAME || ' ' || IE.FIRSTNAME Instructor,
            /* FLOOR(COUNT( distinct MTM.EVAL_SUBMITTED_ID )
                        OVER (
                           PARTITION BY cd.cOUNTRY,
                                        MTMX.MTM_CATEGORY,
                                        mtm.ANSWER
                          -- ORDER BY mtm.ANSWER
                        )
                     / COUNT (
                          DISTINCT MTMX.MTM_QUESTION
                       )
                          OVER (
                             PARTITION BY CD.COUNTRY,
                                          MTM.EXTERNAL_COURSE_ID,
                                          MTM.ANSWER,
                                          MTMX.MTM_CATEGORY
                              ))
                  stu_cnt,
                  */
            MTM.EVAL_SUBMITTED_ID,
            MTM.QUESTION,
            MTM.QUESTION_ID,
            MTM.QUESTION_CATEGORY,
            --MTMX.VARIABLE_NAME,
            MTM.ANSWER,
            MTM.ANSWER_TYPE
     FROM                  mtm_survey_data mtm
                        LEFT JOIN
                           event_dim ed
                        ON mtm.EXTERNAL_CLASS_ID = ed.EVENT_ID
                     LEFT JOIN
                        course_dim cd
                     ON ED.COURSE_ID = CD.COURSE_ID
                        AND ED.COUNTRY = CD.COUNTRY
                  JOIN
                     MTM_CATEGORY_XREF mtmx
                  ON mtm.QUESTION_id = mtmx.QUESTION_ID
                     AND CD.COURSE_PL = UPPER (mtmx.product_line)
               LEFT JOIN
                  INSTRUCTOR_EVENT_V ie
               ON ED.EVENT_ID = IE.EVXEVENTID AND IE.FEECODE = 'INS'
            JOIN
               time_dim td
            ON ED.END_DATE = TD.DIM_DATE
    WHERE --  (CD.COURSE_PL LIKE 'MICROSOFT%' OR CD.COURSE_PL LIKE 'IBM')    and
         MTM.ANSWER_TYPE = 'Likert' AND ED.END_DATE > '01-SEP-2013' --AND '31-AUG-2013';
--order by TD.DIM_YEAR, TD.DIM_MONTH_NUM, ED.COUNTRY, CD.COURSE_PL, CD.COURSE_MOD, CD.COURSE_CODE, ED.EVENT_ID, MTM.EVAL_SUBMITTED_ID, MTM.QUESTION_CATEGORY,MTM.QUESTION_ID;


