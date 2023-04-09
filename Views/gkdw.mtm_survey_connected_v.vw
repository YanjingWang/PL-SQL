DROP VIEW GKDW.MTM_SURVEY_CONNECTED_V;

/* Formatted on 29/01/2021 11:23:24 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.MTM_SURVEY_CONNECTED_V
(
   COURSE_PL,
   COURSE_CODE,
   EVENT_ID,
   CONNECTED_C,
   CONNECTED_V_TO_C,
   END_DATE,
   EVAL_SUBMITTED_ID,
   QUESTION_CATEGORY,
   VARIABLE_NAME,
   ANSWER,
   ANSWER_TYPE
)
AS
   SELECT   CD.COURSE_PL,
            CD.COURSE_CODE,
            ED.EVENT_ID,
            ED.CONNECTED_C,
            ED.CONNECTED_V_TO_C,
            ED.END_DATE,
            MTM.EVAL_SUBMITTED_ID,
            MTM.QUESTION_CATEGORY,
            MTMX.VARIABLE_NAME,
            MTM.ANSWER,
            MTM.ANSWER_TYPE
     --mtm.*, MTMX.VARIABLE_NAME, MTMX.QUESTION_ID, MTMX.MTM_CATEGORY, MTMX.MTM_QUESTION
     FROM            mtm_survey_data mtm
                  LEFT JOIN
                     event_dim ed
                  ON mtm.EXTERNAL_CLASS_ID = ed.EVENT_ID
               LEFT JOIN
                  course_dim cd
               ON ED.COURSE_ID = CD.COURSE_ID AND ED.COUNTRY = CD.COUNTRY
            JOIN
               MTM_CATEGORY_XREF mtmx
            ON mtm.QUESTION_id = mtmx.QUESTION_ID
               AND CD.COURSE_PL = UPPER (mtmx.product_line)
    WHERE   (CD.COURSE_PL LIKE 'MICROSOFT%' OR CD.COURSE_PL LIKE 'IBM')
            AND ED.END_DATE BETWEEN '01-AUG-2013' AND '31-AUG-2013';


