# Basic GIT Commands

Start a git repo
```
git init
```
Add a remote repository
```
git remote add origin <url>
```
See remote repository
```
git remote -v
```
Add files to be commited
```
git add .
```
Commit files
```
git commit -m "<description>"
```
View history change
```
git log
```
Reset the last commit
```
git reset --soft HEAD~1
```
Reset the last commit and change the file
```
git reset --hard HEAD~1
```
Push your changes to a remote repository
```
git push origin <branch>
```
Pull your changes from a remote repository
```
git pull origin <branch>
```
Get git current status
```
git status
```
Get git local branch
```
git branch
```
Change branch
```
git checkout -b <branch-name>
```
See the difference beteween branches
```
git differ <branch-name-1> <branch-name-2>
```
Merge the branches
```
git merge <branch-name>
```

