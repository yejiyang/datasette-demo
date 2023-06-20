-- example 1, find all OrgA's project
select  organization.organization_id, organization, project_id, project from organization
join project on organization.organization_id = project.organization_id
where "OrgA" in (organization.organization)

-- example 2, get all OrgA's offshore locations
select  organization.organization_id, organization, project.project_id, project, location_id, location, location_type_id, created_by from organization
join project on organization.organization_id = project.organization_id
join location on location.project_id = project.project_id
where "OrgA" in (organization.organization) and location_type_id = 2
