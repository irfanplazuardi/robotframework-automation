### API Documentation

[reqres.in](https://reqres.in/)

### What Need To Be Installed

To run API automation using robot framework make sure to install [python](https://www.python.org/downloads/) first in your computer then install robot framework libraries as follow:

- **robot framework**

```
pip install robotframework
```

- **request library**

```
pip install robotframework-requests
```

- **json library**

```
robotframework-jsonlibrary
```

### How To Run Automation

After installed required libraries to run the automation we could start by:

1. Open project in vscode and create **app_variables.robot** file inside API/constant directory and input variable as follow:

```python
*** Variables ***
${EMAIL}    #input value here
${PASSWORD} #input value here
${TOKEN}    #input value here
${INVALID_EMAIL}    #input value here
${ID}    #input value here
```

2. To execute testcase can simply click the play button beside testcase after adding extension [robotframework](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp) in vscode or type this command inside terminal as example:

```
//Single test case run
robot --test "Successfull Login With Valid Email And Password" API/testcase/login.robot

//Run test suite
robot API/testcase/login.robot
```

3. to see the report can access **report.html** or to see log **log.html** after running the automation
