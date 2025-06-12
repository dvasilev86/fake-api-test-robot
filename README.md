# Setup on Windows

prerequisites: git, PyCharm, hyper robot framework plugin for PyCharm 

## Installation

#### Windows 
1. install python as per site instructions
2. create virtual environment in a directory of your choice: `python -m venv .env` 
3. activate the venv in cmd: `C:\> <Virtual Env Path>\Scripts\activate.bat` 
4. alternatively do that in PowerShell: `PS C:\> <venv>\Scripts\Activate.ps1`
(more on https://docs.python.org/3/library/venv.html)
4. in the same prompt/dir, install the packages from `requirements.txt` to the venv with: `pip install -r requirements.txt`

You should be good to move on to the next section.

#### Linux/MacOS

Todo

## Running tests
example command to run all tests is: 
`robot -d reports online_bookstore`  
this will run all tests found under the folder `online_bookstore` and put the reports in `reports/` directory

## Maintaining tests
this guide suggests PyCharm with Hyper Robot Framework plugin, but other IDEs/Text Editors can be used as desired
