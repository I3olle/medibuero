# Medibuero Excel

This project aims to provide a simple yet helpful solution for digitalising the mass of data produced by the ongoing patient visits which may be hectic from time to time. It contains a place for future to dos, data about the docs/offices/hopitals, data about the appointments and a checklist when talking to a patient which produces a printable handout for both patient and doctor.


## Prerequisites

- Git
- Libreoffice
- (dunstify)

### Git

Git is used for a versioned backup. What does that mean? It means that every time you run the backup script it backs up the Excel file but only makes a note of the changes. That way you can use git (or tools with git) to go back in time in case you make a mistake without using up too much space and even see the exact changes.


### Libreoffice

This is the program used to create the sheets and tables. It is the open source office suite similar to Microsoft Office. The counterpart to Microsoft Excel is LibreOffice Calc. It is similar and many things working in Microsoft Excel or Google Sheets also works in LibreOffice Calc. It is not the same though so don't expect to be able to copy the things you want exactly withoutany changes from one program to another.

### Dunsitfy

Dunsitfy is a nice to have for linux machines and shows little notification icons when running the backup script but can be ignored. If the notifications are not needed, just delete the linues containing "dunstify" form the backup.sh script.

## Usage

The document consists of a few sheets. The sheets are:

- Patients
- Doc
- Appointments
- Inventory
- Checklist
- Handout

### Patients

In patients you store data related to the Patient. Not a lot of data is stored. Only the bare minimum. 

- ID
    - This is a continuous ID used to match information in other tables
- First Name
    - The last name is not needed
- Birthyear
    - If you have an exact day you can enter it, otherwise just enter any date of the approximate year
- Age
    - The age is calculated from the birthyear
- Sex
    - Can be m/f/o
- EU
    - Can be yes/no
- Insurance
    - Can be yes/no
- Phone number
- Languages
- Last appointment
    - This is not set manually but is something shown for people who have been at the Medibüro before
- Last Reason
    - Same as last appointment
- Last Doc
    - Same as last appointment

### Doc

In here you store data about all the doctors, hospitals and offices.

- ID
    - This is a continuous ID used to match information in other tables
- Name
    - Name of the doctor or the center
- Donation
    - Info whether the doc donates the work or whether the Medibüro needs to pay afterwards
- Visits past month
    - Shows the number of visits the doctor had within the past 4 weeks
- Upcoming visits
    - Shows the number of all future visits of the doc
- Combined visits
    - Shows the sum of the previous numbers
- Unavailable from
    - Date in case a place is unavailable due to holidays or similar
- Unavailable till
    - Date until a place is unavailable. This field turns red in case it is in the future.
- Phone number
    - That's where you call.
- Address
    - The address as a free field
- Opening hours
    - Free text field in which you can even enter multiple rows (Ctrl + Enter)
- Languages
    - Multiple fields for languages. Keeping the languages in multiple fields helps filtering for them later on
- Expertise
    - Multiple fields for skills. Keeping the languages in multiple fields helps filtering for them later on

### Appointments

Enter the appointments here to keep track of them.

- ID
    - This is a continuous ID used to match information in other tables
- Patient ID
    - Enter the ID of the patient here
- Patient Name
    - Shows the name of the patient
- Doc ID
    - Enter the ID of the doc/office/hospital here
- Doc Name
    - Shows the name of the doc/office/hospital
- Date
    - Date of the appointment
- Reason
    - Short description of the reason

### Inventory

Keep track of all the meds we have and see whether they need to be restocked

- Name
    - Name of the product
- Quantity
    - Quantity (should contain a condtional formatting. See below to learn more about it)
- Use Case
    - Short description to prevent handing out the wrong medicine with a similar name
- Source
    - Where to call in case you need to restock


### Checklist

A checklist to go through when talking to a patient. It is not a must to enter data in every row but it can help not forgetting anything no matter how simple it is or how often one has done it. Some of the data in here is used to generate the handout.

### Handout

The Handout is mostly generated with data from the checklist. It is spaced out to be printed on a A4 page and can be split in two so the patient and doc/office/hospital each gets the data needed.


### To do list

Really simple to do list to keep track of things needed to be done outside of the medibüro session. Maybe it is calling a doctor for an appontment, maybe it is someone who left a messsage which needs to be discussed.
Simply delete the row once it is actually done.

## Making changes

This document is not perfect and many things are still missing. But that's also the reason why excel/calc was chosen. I hope that this enables everyone to make changes to the document as needed.

### Formulas explained

#### Date of the last appointment

=IF(
    IFNA(
        MAXIFS(
            $Appointments.$F:$Appointments.$F;$Appointments.$B:$Appointments.$B;A5
        ); ""
    )=0; ""; 
    IFNA(
        MAXIFS(
            $Appointments.$F:$Appointments.$F;$Appointments.$B:$Appointments.$B;A5
        ); ""
    )
)

MAXIFS finds the largest number of $Appointments.$F (the date) where $Appointments.$B (the column with the patient IDs) contains A5 (Patient ID)
The reason why it is repeated is that the IF checks whether we just get a "0" which happens when the appointment field is empty.
And the IFNA checks for the #N/A error which can also happen if the Patient ID is not filled yet. That's why the formula becomes very long even though the origanal formula is just "MAXIFS($Appointments.$F:$Appointments.$F;$Appointments.$B:$Appointments.$B;A5)"


#### Last reason for an appointment from the patients sheet:

=IF(
    IFNA(
        INDEX(
            $Appointments.G:$Appointments.G; MATCH(
                A3&J3; $Appointments.$B:$Appointments.$B&$Appointments.$F:$Appointments.$F; 0
            )
        ); ""
    )=0;""; 
    IFNA(
        INDEX(
            $Appointments.G:$Appointments.G; MATCH(
                A3&J3; $Appointments.$B:$Appointments.$B&$Appointments.$F:$Appointments.$F; 0
            )
        ); ""
    )
)
Yes it is long. Let's start with the MATCH
Match uses the combination of the Patient ID and the date of the last appointment A3&J3 and matches it with the appointments table. 
When it matches it is used by the index to show the content of the column G in the appointments sheet. The G column in this case is the reason for the appointment.
Just like before IF and IFNA checks for empty cells and just shows an empty cell in that case.

Those formulas are pretty much the most common formulas used in this document in order to help not having to type the same thing over and over.

### Validity

Some fields such as EU or insurance have a vailidity checker. This can be editied via Data > Validity
In these simple cases it contains a list of the allowed values. This is meant to help minimise typos. 

An advanced example would be the checklist field for which expertise would help. This uses a cell range 
$Doc.$P2:$Doc.$T1600
This is the reason why the "services offered" part of the "Doc" sheet is split into multiple columns and helps scroll through a list of all offered services which hopefully makes it easier to search for the best doc/office/hospital in the next step.


#### Conditional Formatting

Highlighting the date of a doc/office/hospital being unavailable if it is in the future is done via conditional formatting.
You can edit it via Format > Conditional > Manage
Maybe this functionality is useful for other cases as well.
For example for the inventory. Create a condition for each medicine to see which meds need to be restocked soon 


## Backup

The backup.sh does two things:

- It converts the .ods file to .fods so it becomes an xml text file. This is necessary to prevent the backup from becoming massive over time.
- After converting the file, it does a git commitwith a timestamp as comment

If you do this the first time you may need to execute the setup.sh or parts of it first
You can copy the entire folder on a backup drive in case the laptop dies on you.



## Missing and ToDo

- [] Spendenquitttung
- [] Quartalsergebnis
- [] Überweisung zum Abheften
- [] Anfahrt zur Praxis
- [] Bilder
- [] Export der Liste an Partnerschaften (Vielleicht einfach nur kopieren der Spalte "Name" in der "Doc" Tabelle?)

