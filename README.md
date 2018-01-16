# z_file_based_popsel
Procedures to allow creation and population of a Banner POPSEL from an externally loaded spreadsheet.

## New JOBSUB Processes

- ZGPPSEL - Load POPSEL from file
- ZGPPURG - Purge POPSEL

#### Building a new POPSEL

- Start with INB form GLRSLCT to define a new POPSEL if it doesn't already exist.
- Application is an organizational area, like a module. For this example we will use STUDENT.
- The Selection ID if a unique identifier/title for this specific POPSEL, lets use 'BATCH_UPDATE_ADVISORS
- The selection description is an admittedly short description, in this case 'students to update advisors'
- Now because we are going to manually load, we can ignore the POPSEL Rules.
- Save the new record.

#### Anatomy of a POPSEL

- A POPSEL has 4 fields use to identify it.
  - Application - the organizational area the POPSEL was defined in, in our case 'STUDENT'
  - Selection - the unique identifier/title of the POPSEL, in our case 'BATCH_UPDATE_ADVISORS'
  - Cretor ID - The Banner ID creator of the original selection definition, in this case me, 'A00350677'
  - User ID - The Banner ID of the person creating the population, or list of students. This would normally be your Banner ID, but in sthis specific case as I'm demonstrating, we will use my Banner ID here as well, 'A00350677'

#### ZGPPSEL - Loading students from the file

- Go to JOBSUB process ZGPPSEL, this is what allows us to load the POPSEL from a file rather than using the INB POPSEL forms
- there are 6 parameters. the first four we described above
  - POPSEL Application - STUDENT
  - POPSEL Selection - BATCH_UPDATE_ADVISORS
  - POPSEL Creator ID - A00350677
  - POPSEL User ID - A00350677
- The last two tell the system where the file can be found.
  - Folder name - 'STUDENT'
    - name of the Oracle directory, or in this context, when you used WINSCP to put the file on the server, the username used to connect.
  - File name - 'advisor_sample_01.txt'
    - the complete file name, including extension fot he file we wish to import.
- REMEMBER - the file must be plain text and contain only the a-numbers. .txt or .csv will both work, but it can have no header nor columns other than a-numbers.
- If you selected DATABASE as your jobsub printer, you can review output, specifically the .lis file to get a log of any errors encountered

#### Verifying the file loaded correctly
One of the many beauties of utilizing POPSEL is we can still use all the Banner forms to interact with the population

- Go to GLAEXTR (or GLIEXTR for inquery mode) to review the popsel you just loaded
- With GLAEXTR you can add or removed specific IDs for your population manually

#### ZGPPURG - Purging a POPSEL

- Running ZGPPSEL multiple times consecutively with different files can be used to add more IDs to the same POPSEL
- ZSPPURG can be used to remove all IDs from a POPSEL if you do not want to include previous loads
- it has only 4 parameters
  - POPSEL Application - STUDENT
  - POPSEL Selection - BATCH_UPDATE_ADVISORS
  - POPSEL Creator ID - A00350677
  - POPSEL User ID - A00350677
- Again, GLAEXTR/GLIEXTR can be used to verify success