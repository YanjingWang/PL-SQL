DROP VIEW GKDW.GK_EVENT_PO_INFO_V;

/* Formatted on 29/01/2021 11:36:48 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EVENT_PO_INFO_V
(
   "Product Line",
   "Fiscal Year",
   "Fiscal Month",
   "Fiscal Week",
   EVENT_ID,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_TYPE,
   START_DATE,
   END_DATE,
   "MEETING DAYS",
   MANAGED_PROGRAM_ID,
   CONTACTID1,
   "Instructor Name",
   "Instructor company",
   "Channel",
   "Modality",
   "Connected C",
   "V Connected to C",
   "# Attendees",
   "PO #",
   "Vendor Name",
   "PO Line #",
   "PO Line Category",
   "PO Line Description",
   "PO Line Quantity",
   "PO Line Unit Price",
   "PO Line Amount"
)
AS
   SELECT   cd.course_pl "Product Line",
            td.dim_year "Fiscal Year",
            td.dim_month "Fiscal Month",
            td.dim_week "Fiscal Week",
            ed.event_id,
            ed.course_code,
            cd.short_name,
            cd.course_type,
            ed.start_date,
            ed.end_date,
            ed.meeting_days "MEETING DAYS",
            ed.managed_program_id,
            gae.contactid1,
            gae.firstname1 || ' ' || gae.lastname1 "Instructor Name",
            iev.account "Instructor company",
            cd.course_ch "Channel",
            cd.course_mod "Modality",
            CASE WHEN ed.connected_c IS NULL THEN 'N' ELSE 'Y' END
               "Connected C",
            CASE WHEN ed.connected_v_to_c IS NULL THEN 'N' ELSE 'Y' END
               "V Connected to C",
            ed.attend_enrollments "# Attendees",
            poh.segment1 "PO #",
            pv.vendor_name "Vendor Name",
            pol.line_num "PO Line #",
            mc.segment1 "PO Line Category",
            pol.item_description "PO Line Description",
            pol.quantity "PO Line Quantity",
            pol.unit_price "PO Line Unit Price",
            pol.quantity * pol.unit_price "PO Line Amount"
     FROM                              event_dim ed
                                    LEFT JOIN
                                       course_dim cd
                                    ON ed.course_id = cd.course_id
                                       AND ed.country = cd.country
                                 LEFT JOIN
                                    GK_ALL_EVENT_INSTR_V gae
                                 ON ed.event_id = gae.event_id
                              INNER JOIN
                                 instructor_event_v iev
                              ON gae.contactid1 = iev.contactid
                                 AND ed.event_id = iev.evxeventid
                           LEFT JOIN
                              time_dim td
                           ON ed.start_date = td.dim_date
                        LEFT JOIN
                           po_distributions_all@r12prd pod
                        ON ed.event_id = pod.attribute2
                     LEFT JOIN
                        po_lines_all@r12prd pol
                     ON pod.po_line_id = pol.po_line_id
                  LEFT JOIN
                     mtl_categories@r12prd mc
                  ON pol.category_id = mc.category_id
               LEFT JOIN
                  po_headers_all@r12prd poh
               ON pod.po_header_id = poh.po_header_id
            LEFT JOIN
               po_vendors@r12prd pv
            ON poh.vendor_id = pv.vendor_id
    WHERE   ed.start_date > '31-DEC-2012'
            AND pod.creation_date > '31-DEC-2012';


