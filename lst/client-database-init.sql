CREATE TABLE Task (
    uid                  VARCHAR             NOT NULL,
    num                  INTEGER             NOT NULL,
    name                 VARCHAR             NOT NULL,
    color                VARCHAR                 NULL,
    shape                VARCHAR                 NULL,
    is_milestone         BOOLEAN             NOT NULL DEFAULT false,
    is_project_task      BOOLEAN             NOT NULL DEFAULT false,
    start_date           DATE                NOT NULL,
    duration             INTEGER             NOT NULL,
    completion           INTEGER                 NULL,
    earliest_start_date  DATE                    NULL,
    priority             VARCHAR             NOT NULL DEFAULT '1',
    web_link             VARCHAR                 NULL,
    cost_manual_value    NUMERIC(1000, 2)        NULL,
    is_cost_calculated   BOOLEAN                 NULL,
    notes                VARCHAR                 NULL,

    PRIMARY KEY (uid)
);
