# Introduction 

This project is an implementation of an interview task. The scope of the task is to create a testing framework which:
- tests a fake API residing here: https://fakerestapi.azurewebsites.net/index.html
- scope of tests is limited to `Books` and `Authors` endpoints
- produce reports on the test executions
- have the project CI-ready
- last but not least, have a thorough README which can guide people how to run and configure this project

# Installation

## Windows 
1. install python as per site instructions https://www.python.org/downloads/ - i chose the latest stable which ATM is 3.13
2. create virtual environment in the project root: `python -m venv .env` - i chose `.env` as directory name, but you can choose differently. make sure your choice is ignored by `.gitignore` so as to not commit it by accident  
3. activate the venv in cmd: `C:\> <venv path>\Scripts\activate.bat` 
4. alternatively do that in PowerShell: `PS C:\> <venv path>\Scripts\Activate.ps1`
(more on https://docs.python.org/3/library/venv.html)
5. in the activated prompt, install the packages from `requirements.txt` to the venv with: `pip install -r requirements.txt`

You should be good to move on to the next section.

## Linux/MacOS (unverified)
1. install or update your python distribution by your prefered package manager
2. create virtual environment in the project root: python -m venv .env - i chose .env as directory name, but you can choose differently. make sure your choice is ignored by .gitignore so as to not commit it by accident
3. activate the venv with `$ source ./<venv path>/bin/activate`
4. in the activated prompt, install the packages from `requirements.txt` to the venv with: `pip install -r requirements.txt`

You should be good to move on to the next section.

# Project Structure

The project utilizes [Robot Framework](https://robotframework.org/). Robot may have a bit unusual syntax for most people that are not familiar with it, as it relies on whitespace as delimiter between calls, arguments, variables and pretty much everything else - one space is treated as part of the name/literal, two+ spaces are considered a delimiter. My own preference for editing Robot code is [PyCharm](https://www.jetbrains.com/pycharm/) with [Hyper RobotFramework Support plugin](https://plugins.jetbrains.com/plugin/16382-hyper-robotframework-support). 

## Notable files

- **requirements.txt** - contains the [pip](https://pypi.org/) packages required for this project to run  
- **.gitignore** - i have put all irrelevant or artifact files into it, but if you choose different IDE (e.g. VSCode) or some something else is different on your platform - the file may require editing before you decide to extend it with version control
- **report.html** - the produced report, either by `robot` or `pabot` commands, the former is the original command to invoke tests, and the latter is the parallel executor
- **online_bookstore/api_paths.resource** - contains URL definitions of the system under test - **SUT** (in this case, our [fake Rest API](https://fakerestapi.azurewebsites.net/index.html)) which are used by the tests to make http calls. Also note that it includes a python (.py) file that resolves configurable variables related to the URLs.
- **.github/workflows/run-all-tests.yaml** - the Github Actions workflow file

## Test Structure

Most Robot tests in this project are using **templating**, which means they use a parametrized keyword and each test case is a **named dataset** that runs the same function (keyword) with different input parameters. This approach is particularly suitable for API endpoints. To spot if a test file (.robot) is templated, look for `Test Template` declaration in the `*** Settings ***` section. Usually, tests that manipulate data would have `Teardown` methods that cleanup artifacts and restore original state of data but in our case the Fake API does not allow data manipulation and this is not implemented in the tests.

## Test Tags

Tests can (and in this project - are) grouped by tags. This can be done in multitude of ways but I have particularly used the `Default Tags` declaration in `*** Settings ***`. This grouping is useful in case you wish to run specific group of tests, based on a tag, and also to review reports with lots of tests - where they can also be narrowed by tag.

# Executing tests

## Locally
You can run tests locally either by `robot` or `pabot` commands. Both options are highly configurable, so I'll only highlight some examples, notable differences and interesting CLI options.

#### Common params
Regardless of which command you choose, you need to specify `env` variable, with defined options being `dev` and `prod`. this will configure the URL of the SUT. example CLI input:
```  
--variable env:dev
```
In fact, any desired variable can be passed like this to the test executor, and later can be used in the test code.

Another very important CLI param is `--outputdir` - it controls where would the artifacts (test reports) be saved. some trivial locations and files are already added in the .gitignore, but be mindful not to commit unnecessary files if you specify something custom here. Typical usage:
```
--outputdir ./reports
```

Yet another useful CLI tool is the control for inclusion/exclusion of tests by tags. This is done with `--include` and `--exclude` params. Example usage:
```
--include Authors --exclude "Create Author"
```
this will run all tests tagged with `Authors` tag, but will exclude `Create Author` tests. Note the quotes - common way to pass argument that has whitespace in itself.  

#### Running tests locally on CLI
Let's add a few example commands of running tests and describe them what they do:

- `robot --variable env:dev --outputdir reports ./online_bookstore` 
- this will use **robot** to **sequentially run** all tests found under `online_bookstore` directory, against `dev` environment, and will produce a report in `results` directory

- `robot --variable env:dev --include "Authors" --exclude "Create Author" ./online_bookstore`
- this will use **robot** to **sequentially run** all "Author" tagged tests, without "Create Author" tagged tests, found under `online_bookstore` directory, against `dev` environment, and will produce a report in the project root directory

- `pabot --testlevelsplit --processes 8 --varialbe env:dev --outputdir results ./online_bookstore`
- this will use **pabot** to fire up 8 testing threads and run in parallel all tests, split on test level (not suite level, where suite means .robot file), found under `online_bookstore` directory, against `dev` environment, and will produce a report in `results` directory 

#### Running tests on CI 
There's a workflow file `.github/workflow/run-all-tests.yaml` which can be used to run the tests in Github Actions. It is also configurable to choose which branch and what environment to use. A complete report is attached to the action's summary, kept 7 days (hardcoded in the yaml file), and also the results' summary is embedded in the github action's summary.

