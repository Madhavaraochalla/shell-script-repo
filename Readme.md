# 🐚 Shell Script Automation Repo

Welcome to the **Shell Script Automation Repository**! This repo helps you **automate common DevOps tasks** like deploying Kubernetes apps, pushing code to GitHub, and managing resources — all with easy-to-use shell scripts.

> 💡 **No prior shell scripting knowledge required!** Just follow the steps and copy-paste the commands.

---

## 📦 What’s Inside?

| Script Name           | What It Does                                                   |
|-----------------------|----------------------------------------------------------------|
| `deploy.sh`           | Deploys a sample app into your local Minikube Kubernetes cluster |
| `delete.sh`           | Cleans up the Kubernetes app deployed by `deploy.sh`           |
| `Push-code.sh`        | Pushes your local code files to your GitHub repo               |
| `delete-repo.sh`      | Deletes a GitHub repo via the GitHub API (with permission)     |
| `deploy-grafana.sh`   | Deploys Grafana dashboard to Kubernetes                        |
| `create-users.sh`     | Creates Linux user accounts from a predefined list             |

---

## 🛠️ Prerequisites

Make sure the following tools are installed before running the scripts:

- ✅ Git: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- ✅ Minikube: [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
- ✅ kubectl: [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- ✅ Docker (Optional for Minikube deployments)
- ✅ GitHub account + [Personal Access Token (PAT)](https://github.com/settings/tokens)

---

## 🚀 How to Use the Scripts

### 🔹 1. Clone This Repo

```bash
git clone https://github.com/Madhavaraochalla/shell-script-repo.git
cd shell-script-repo

# Your GitHub username and repo name
GITHUB_USER=""<Your user name>
REPO_NAME="" <Repo-name>

# Files to commit (Ensure these are valid files in the current directory)
FILES=("") file to commit


# Files to remove (if needed)
FILES_TO_REMOVE=("") files remove from github

Pass token
export GITHUB_TOKEN=****************

to run script
./File-name


Usage  

Normal run (actually does everything):

    ./your-script.sh


Dry-run mode (only shows what it would do):

    ./your-script.sh --dry-run 



What’s happening in the script:

The script adds files that you’ve listed in the FILES array (e.g., delete-repo.sh, create-users.sh, etc.). This part is done with:


for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        if ! $DRYRUN; then
            git add "$file"
        fi
        echo "Added $file"
    else
        echo "Warning: $file does not exist."
    fi
done
You also have an optional git add . command (which can add all files), but it's commented out by default, like this:

### Optional: Stage all local changes (Uncomment the below line if you want to add all files)
# $DRYRUN || git add .


When ever using git add. comment this line first then only git add . works 

# Files to commit
FILES=("delete-repo.sh" "create-users.sh" "deploy-grafana.sh" "Push-code.sh" "delete.sh" "deploy.sh" "Readme.md")