## Git Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Git Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/git-cheat-sheet.jpeg)

### Questions

- **Basic questions**:
    - What is `git`?
        + `git` it is a software for version control.
    - Difference between `git` and `github`?
        + `git` is the software and `github` is a website and service in wich you can save your `git` code.
    - What is a branch in `git`?
        + Branch in Git is similar to the branch of a tree. Analogically, a tree branch is attached to the central part of the tree called the trunk. While branches can generate and fall off, the trunk remains compact and is the only part by which we can say the tree is alive and standing. Similarly, a branch in Git is a way to keep developing and coding a new feature or modification to the software and still not affecting the main part of the project.
    - How can you create a branch based on another branch?
        + First you need to `checkout` the branch you want to copy and then create the new branch `git branch branch-name` and then move to that branch `git checkout branch-name` you can also only runs  `git checkout -b branch-name`
    - What is the command you can use to write a commit message?
        + The command that is used to write a commit message is `git commit –a`.  The `–a` on the command line instructs git to commit the new content of all tracked files that have been modified. You can use `git add<file>` before git commit `–a` if new files need to be committed for the first time.
    - How can you create a repository in Git?
        + In Git, to create a repository, create a directory for the project if it does not exist, and then run command “git init”. By running this command .git directory will be created in the project directory, the directory does not need to be empty.
    - Let's say that you have changed your code and you want to send it to your remote repo, how can you achive that?
        + need to run:
            - git status (not necessary but good practice).
            - git add file-name
            - git commit -m
            - git push
    - What is ‘head’ in git and how many heads can be created in a repository?
        + `head` is simply a reference to a commit object. In every repository, there is a default head referred as “Master”.  A repository can contain any number of heads.

- **Advance questions**:
    - What is a `fork`?
        +  A copy of a repository (repo) that sits in your account rather than the account from which you forked the data from.
    - What are the 2 ways to integrate changes from one branch to another?
        + `merge` and `rebase`.
    - What is `git rebase`?
        + Is to put your code at the top of the log, like rebasing all the other code and reorg the complete history.
    - How can you re-write the commit message?
        + `git commit --amend`
    - What is the difference between the `git diff` and `git status`?
        + `git diff` is similar to `git status`, but it shows the differences between various commits and also between the working directory and index.
    - What is “Staging Area” or “Index” in GIT?
        + Before completing the commits, it can be formatted and reviewed in an intermediate area known as ‘Staging Area’ or ‘Index’.
    - What is GIT stash?
        + GIT stash takes the current state of the working directory and index and puts in on the stack for later and gives you back a clean working directory.  So in case if you are in the middle of something and need to jump over to the other job, and at the same time you don’t want to lose your current edits then you can use GIT stash.
    - How will you know in GIT if a branch has been already merged into master?
        + git branch –merged --> lists the branches that have been merged into the current branch
        + git branch --no merged --> lists the branches that have not been merged
    - What does commit object contain?
        + a) A set of files, representing the state of a project at a given point of time
        + b) Reference to parent commit objects
        + c) An SHAI name, a 40 character string that uniquely identifies the commit object
    - What is conflict in git and how can you solve it?
        + A ‘conflict’ arises when the commit that has to be merged has some change in one place, and the current commit also has a change at the same place. Git will not be able to predict which change should take precedence. To resolve the conflict in git, edit the files to fix the conflicting changes and then add the resolved files by running “git add” after that to commit the repaired merge,  run “git commit”.  Git remembers that you are in the middle of a merger, so it sets the parents of the commit correctly.
    - What does ‘hooks’ consist of in git?
        + This directory consists of Shell scripts which are activated after running the corresponding Git commands.  For example, git will try to execute the post-commit script after you run a commit.
    - What is the difference between `git log` and `git reflog`?
        + `git log` shows the current HEAD and its ancestry. That is, it prints the commit HEAD points to, then its parent, its parent, and so on. It traverses back through the repo's ancestry, by recursively looking up each commit's parent.<br>(In practice, some commits have more than one parent. To see a more representative log, use a command like `git log --oneline --graph --decorate`.)<br>`git reflog` doesn't traverse HEAD's ancestry at all. The reflog is an ordered list of the commits that HEAD has pointed to: it's undo history for your repo. The reflog isn't part of the repo itself (it's stored separately to the commits themselves) and isn't included in pushes, fetches or clones; it's purely local.
    - What is the difference between `git remote` and `git clone`?
        + `git remote add`  just creates an entry in your git config that specifies a name for a particular URL.  While, `git clone` creates a new git repository by copying and existing one located at the URI.
    - What is `gitflow`?
        + Giflow is an alternative Git branching model that involves the use of feature branches and multiple primary branches. It was first published and made popular by Vincent Driessen at nvie. Compared to trunk-based development, Giflow has numerous, longer-lived branches and larger commits. Under this model, developers create a feature branch and delay merging it to the main trunk branch until the feature is complete. These long-lived feature branches require more collaboration to merge and have a higher risk of deviating from the trunk branch. They can also introduce conflicting updates.
        ![Git flow](https://github.com/DigitalOnUs/devops_interviews/blob/master/topics/git/git-flow.png)
    - How can yo ustart working with `gitflow`?
        + You can get the git flow extention library and then execute: `git flow init`.
