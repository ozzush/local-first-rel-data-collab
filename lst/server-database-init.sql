-- Task start date and duration shall be changed as a whole
CREATE TABLE TaskDates (
    uid                 VARCHAR(128) PRIMARY KEY REFERENCES TaskName,
    start_date          DATE         NOT NULL,
    duration_days       INT          NOT NULL DEFAULT 1,
    earliest_start_date DATE
);

-- Integer valued properties
CREATE TABLE TaskIntProperties (
    uid                 VARCHAR(128) REFERENCES TaskName,
    prop_name           TaskIntPropertyName,
    prop_value          INT,
    PRIMARY KEY (uid, prop_name)
);

----------------------------------------
-- Other component tables are omitted --
----------------------------------------

-- Updatable view which collects all task properties in a single row. 
-- Inserts and updates are processed with INSTEAD OF triggers.
CREATE VIEW Task AS
SELECT
    TaskName.uid,
    num,
    name,
    start_date,
    duration_days AS duration,
    earliest_start_date,
    is_cost_calculated,
    cost_manual_value,
    is_milestone,
    is_project_task,
    MAX(TIP.prop_value) FILTER (WHERE TIP.prop_name = 'completion' AS completion,
    MAX(TTP.prop_value) FILTER (WHERE TTP.prop_name = 'priority')  AS priority,
    MAX(TTP.prop_value) FILTER (WHERE TTP.prop_name = 'color')     AS color,
    MAX(TTP.prop_value) FILTER (WHERE TTP.prop_name = 'shape')     AS shape,
    MAX(TTP.prop_value) FILTER (WHERE TTP.prop_name = 'web_link')  AS web_link,
    MAX(TTP.prop_value) FILTER (WHERE TTP.prop_name = 'notes')     AS notes
FROM TaskName
        JOIN      TaskDates USING (uid)
        LEFT JOIN TaskIntProperties TIP USING (uid)
        LEFT JOIN TaskTextProperties TTP USING (uid)
        LEFT JOIN TaskCostProperties TCP USING (uid)
        LEFT JOIN TaskClassProperties TCLP USING (uid)
GROUP BY TaskName.uid, TaskDates.uid, TCP.uid, TCLP.uid;
