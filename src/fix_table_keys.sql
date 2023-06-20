-- Step 1. Create new tables with PRIMARY KEY and FOREIGN KEY
CREATE TABLE [organization_modified] (
        [organization_id] text PRIMARY KEY,
        [organization] text
);
CREATE TABLE [project_modified] (
        [project_id] text PRIMARY KEY,
        [organization_id] text,
        [project] text,
        FOREIGN KEY (organization_id) REFERENCES organization(organization_id)
);
CREATE TABLE [location_modified] (
        [location_id] text PRIMARY KEY,
        [project_id] text,
        [location_type_id] integer,
        [created_by] text,
        [location] text,
        FOREIGN KEY (project_id) REFERENCES project(project_id)
);


-- Step 2. Copy data from old tables to new temp tables
INSERT INTO organization_modified SELECT * FROM organization;
INSERT INTO project_modified SELECT * FROM project;
INSERT INTO location_modified SELECT * FROM location;




-- Step 3. Delete temp modified tables and rename tables
DROP TABLE organization;
ALTER TABLE organization_modified RENAME TO organization;
DROP TABLE project;
ALTER TABLE project_modified RENAME TO project;
DROP TABLE location;
ALTER TABLE location_modified RENAME TO location;
