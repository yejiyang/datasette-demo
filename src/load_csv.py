import csv_to_sqlite

input_files_folder = "csv_files"

options = csv_to_sqlite.CsvOptions()

input_files = [
    "./csv_files/organization.csv ",
    "./csv_files/project.csv ",
    "./csv_files/location.csv ",
]

csv_to_sqlite.write_csv(input_files, "datasette-demo.db", options)
