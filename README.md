# satellite-position-calculation-mapping

![screen_merge](https://github.com/egemengulpinar/satellite-position-calculation-mapping/assets/71253469/a8e43c89-dc7e-4c7f-811a-033e1e454db2)

The subject of the study is to conduct research on the BeiDou satellite systems developed by China and to calculate the positions of the satellites. In this study, satellite positions were calculated using BeiDou-specific formulation with data received from BeiDou satellites, and then visualized on a world map with latitude, longitude, and altitude information.

The study concluded that some satellite data belonging to BeiDou (obtained from NASA) are partially faulty and need to be revised for successful satellite position results. Additionally, it was found that satellite position calculation varies depending on the types of orbits **(GEO-MEO-IGSO)** in which the satellites are placed. These conclusions were inferred after examining various articles, documents, and writings related to BeiDou satellite systems, and the accuracy of satellite positions was verified and confirmed through online testing.

Important details distinguishing BeiDou from other constellations were identified. Despite the lack of a clear solution method in articles and documents, an individually developed idea and solution method to overcome the problem were tested and finalized in this study.
# Demo

### Demo : Satellite Movements



https://github.com/egemengulpinar/satellite-position-calculation-mapping/assets/71253469/7ae52bf2-9a4c-43aa-bd22-0bcd4de7abcf




### Demo : Satellite Label Detail


https://github.com/egemengulpinar/satellite-position-calculation-mapping/assets/71253469/91af3470-a465-4e27-a942-57448e766dc2




## File Hierarchy
- `/code`             :   The codes developed during the project are located in this folder. Information on how to run the codes and their dependencies can be found in the `About the Codes` section.
- `/datasets`         : The datasets created and obtained during the internship are available in this folder. Information on how the datasets were created, what they contain, and how they should be used is explained under the `datasets` title.
- `/etc`              : Important resources related to the internship are shared here.



## About the Codes
The creation of the codes prioritizes the use of a class structure and modularity. If we list the MATLAB(.m) files included in the project;
1. **`computeposition.m`** 
2. **`keplerEq.m`**
3. **`main.m`**
4. **`R_matrix.m`**
5. **`read_BeiDou_Constellation.m`**
6. **`read_files.m`**
7. **`readRinexNav.m`**

If we list the text document (.txt) files within the scope of the project;
1. **`files_name.txt`**
2. **`BeiDouConstellationStatus.txt`**

If we list the image (.png) files within the scope of the project;
1. **`satellite.png`**

### About Ephemeris and Rinex Parameters

![rinex-ephemeris-parameters](https://github.com/egemengulpinar/satellite-position-calculation-mapping/assets/71253469/c20cf368-9072-4ead-a605-5e7ec6a13364)


## Working Method
SUMMARY: The person who wants to run the project can confirm the correctness of parts **1.** and **2.** without reading the lines below and run the project using the data available in the project [the project should run from the main]. If it is desired to display in real-time or at a standstill, the comment lines in the code can be followed. During the visualization of the project, other information of the satellite can be displayed by clicking on the satellites with the mouse.
If there are other RINEX data for BeiDou and it is desired to try them, the steps below can be followed to ensure the whole process can be carried out in a comprehensible way.

The project is managed through the  **`main.m`** file and other files are being called. First, some configurations need to be made within the  **`main.m`** file. These are;

1. In the code line 1. **[data_name] = read_files(" ")**, the name of the **`files_name.txt`** file located in the current **`/code`** folder should be written. Any text file can also be added here. The purpose of this text file should be to list all the names of the files in the folder where the rinex files are kept. For example, location information such as "datasets/`ASCG00SHN_R_20210250000_15M_CN.rnx` should be entered.
*The reason for this is related to the cessation of visualization and data acquisition studies within the scope of the project, and the current project draft is found sufficient.*

2. Next, in the same file, in the **"index_of_data=1:*number of satellite*"** loop beginning, a value as many as the number of data read in the **[data_name]** part should be entered. Files will be read and calculated up to this number.

3. The **[datas] = readRinexNav(data_name(index_of_data))** section sends the information of the file it reads in the folder where the RINEX files are to the **`readRinexNav.m`** file, and the calculated value is returned to the **[datas]** array.

4. In the **`readRinexNav.m`** file, the received data is read iteratively. It performs the reading and parsing of ephemeris data by removing errors specific to BeiDou. The relevant data is stored in the **beidouEphemeris** variable in the order in the RINEX format and sent back to the main.m file.

5. The format of the sent (**datas**) file is in struct format and the data inside can be accessed as **datas.beidouEphemeris** and this file is saved to the **beidou_datas** variable.

6. In the computeposition **computeposition (beidou_datas)** section, the parameters sent are processed in **`computeposition.m`** and perform position calculation. The returned values are 6 in total. These are;

- Longitude
- Latitude
- Altitude
- name
- exec
- Satellitesinfo

are stored in variables. In this part, the prepared Kepler equation is used for the calculation, the **`keplerEq.m`** file with the Kepler equation is run. The returned values are used in the calculation sections.

7. In the **read_BeiDou_Constellation("BeiDouConstellationStatus.txt")** section, the position of the **`BeiDouConstellationStatus.txt`** text document is written exactly and sent to enter the read_BeiDou_Constellation.m file. All known constellation information of BeiDou in this file is read and stored in the **[Beidou_Constellation]** variable.

8. The parameters in the **"iconDir"** and **"iconFilename"** sections should remain constant, can be changed as desired.
**"iconDir"** shows the location of the current satellite icon.
**"iconFilename"** names the existing **`satellite.png`** file and its location by combining the full file name with the fullfile function.

9. The subsequent code blocks execute the visualization process embedded in the **`main.m`** It does this through the Web Map Display plugin in MATLAB. This plugin must be installed. Displaying satellite positions on the label, revealing their information is accomplished through the **webmap** function.

## About Datasets
Data from the [NASA Earth Data](https://cddis.nasa.gov/archive/gnss/data/highrate/) platform providing data for BeiDou throughout the project has been used. These data were tried in the years 2020-2021 and the xx**f** file was selected. The **f** value here is the code of the data provided for BeiDou satellites.
The reason for preferring this platform was that BeiDou navigation data could not be obtained from another source. Only this platform was used as a source within the scope of the project. However, it is stated that the data here will give more reliable results by resolving the BeiDou satellite information packages over UBlox.
Sample datasets are located in the `/datasets` folder. The data here can be used for testing purposes.
The data are in RINEX 3.04 - 3.03 format, and operations were carried out according to the data order and guidelines specified in the [RINEX Documentation](http://acc.igs.org/misc/rinex304.pdf). The project reads and processes files in the RINEX dataset format. Files to be used as a dataset should be in this format

## About the Report
The report of the project is located in the`/docs` folder. The report, which is quite comprehensive and presents all the details, is explained step by step in an easy-to-understand format.
Besides the report, there are explanatory lines in all code lines, making it easier for the person reading the code.

## Other Important Points
In the project, the results of the GEO satellites in the satellite position calculation cannot be calculated as a result of the data obtained from NASA Earth Data. The reason for this is explained in detail in the related report file.
It can be said that the project has been examined in detail in many different areas, not only satellite position calculation, but also the arrangement of RINEX data, visualization process, differences in the orbital constellation calculations of BeiDou. For all possible information about this, you can reach our report under `/docs`.
