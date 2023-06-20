import pandas as pd
import random
import numpy as np


def generate_dummy_project_data():
    # Define the project_id list
    project_id = ["proj" + str(i).zfill(4) for i in range(1, 1001)]

    # Define the organization_id list
    organizations = ["OrgA", "OrgB", "OrgC", "OrgD", "OrgE"]
    organization_id = [random.choice(organizations) for _ in range(1000)]

    # Define the project list
    project = ["Proj " + str(i).zfill(4) for i in range(1, 1001)]

    # Create a dataframe
    df = pd.DataFrame(
        {
            "project_id": project_id,
            "organization_id": organization_id,
            "project": project,
        }
    )

    # Write dataframe to csv
    df.to_csv("dummy_project_data.csv", index=False, quotechar='"', quoting=1)


def generate_dummy_location_data():
    # Define the location_id list
    location_id = ["loc" + str(i).zfill(7) for i in range(1, 100001)]

    # Define the project_id list
    project_id = ["proj" + str(random.randint(1, 1000)).zfill(4) for _ in range(100000)]

    # Define the location_type_id list
    location_type_id = [random.randint(1, 2) for _ in range(100000)]

    # Define the created_by list
    domain_names = ["orga.com", "orgb.com", "orgc.com", "orgd.com", "orge.com"]
    unique_emails = [
        "user" + str(i).zfill(3) + "@" + random.choice(domain_names)
        for i in range(1, 101)
    ]
    created_by = np.random.choice(unique_emails, size=100000)

    # Define the location list
    location = ["location " + str(i) for i in range(1, 100001)]

    # Create a dataframe
    df = pd.DataFrame(
        {
            "location_id": location_id,
            "project_id": project_id,
            "location_type_id": location_type_id,
            "created_by": created_by,
            "location": location,
        }
    )

    # Write dataframe to csv
    df.to_csv("dummy_location_data.csv", index=False, quotechar='"', quoting=1)


generate_dummy_project_data()
generate_dummy_location_data()
