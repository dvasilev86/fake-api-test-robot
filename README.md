# Setup on Windows

prerequisites: git, PyCharm, hyper robot framework plugin for PyCharm 

## Installation
1. install python as per site instructions
2. create virtual environment in a directory of your choice: python -m venv /path/to/new/virtual/environment 
3. activate the venv in cmd: C:\> <venv>\Scripts\activate.bat 
(more on https://docs.python.org/3/library/venv.html)
4. install the packages from requirements.txt to the venv in order to run the project

## Running tests
example command to run all tests is: 
`robot -d reports online_bookstore`  
this will run all tests found under the folder `online_bookstore` and put the reports in `reports/` directory

## Maintaining tests
this guide suggests PyCharm with Hyper Robot Framework plugin, but other IDEs/Text Editors can be used as desired
