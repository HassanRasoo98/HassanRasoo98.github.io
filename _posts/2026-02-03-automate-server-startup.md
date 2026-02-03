# Automate Server Startup in VSCode
One of the most frustrating things to do is to use the terminal to run the same commands again and again to start and close your frontend and the backend servers. In small projects it is easy to manage and redo but as the projects grow large and there are multiple services to mangage, this becomes redundant.

## Solution: .vscode/tasks.json
A simple trick to solve this problem is to use a tasks.json file to manage your services inside of vscode. Just create a .vscode (hidden) folder inside your project and create a tasks.json file inside it. Paste the following code inside the json file:
```
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Run Frontend",
            "type": "shell",
            "command": "cd frontend && npm run dev",
            "group": "build",
            "problemMatcher": []
        },              
        {
            "label": "Run Backend",
            "type": "shell",
            "command": "cd backend && source .venv/bin/activate && uvicorn main:app --reload",
            "group": "build",
            "problemMatcher": []
        },
        {
            "label": "Run Full Stack",
            "dependsOn": ["Run Backend", "Run Frontend"],
            "dependsOrder": "parallel",
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```
Note: The script assumes that you have a python fastapi backend and a react or next js frontend. It activates the virtual environment in the backend and then starts the server. You must preinstall teh frontend and the backend requirements.

## How to use
After the script has been created, you can use it in one of the following ways:
1. From the terminal options on the top -> run build task. OR
2. Enter combination 'ctrl+shit+p' then run build task.
Using this the terminals and the servers start automatically. No need to manually type in the commands again and again.

This simple script can be extended to run and manage other services as well like celery, flower etc. Feel free to use or extend it. Suggestions are welcome. Feel free to reach out to my email in case of any queries or issues: 'hassanrasool1057@gmail.com'
