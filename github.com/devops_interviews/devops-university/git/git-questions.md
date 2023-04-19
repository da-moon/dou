## Git Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

- **Basic questions**:
    - What is `git`?
        + `git` it is a software for version control.
    - Difference between `git` and `github`?
        + `git` is the software and `github` is a website and service in wich you can save your `git` code.
    - What is a branch in `git`?
        + Branch in Git is similar to the branch of a tree. Analogically, a tree branch is attached to the central part of the tree called the trunk. While branches can generate and fall off, the trunk remains compact and is the only part by which we can say the tree is alive and standing. Similarly, a branch in Git is a way to keep developing and coding a new feature or modification to the software and still not affecting the main part of the project.
    - How can you create a branch based on another branch?
        + First you need to `checkout` the branch you want to copy and then create the new branch `git branch branch-name` and then move to that branch `git checkout branch-name` you can also only runs  `git checkout -b branch-name`
    - How can you delete a branch?
        + `git branch -D branch-name`
    - Let's say that you have changed your code and you want to send it to your remote repo, how can you achive that?
        + need to run:
            - git status (not necessary but good practice).
            - git add file-name
            - git commit -m
            - git push
- **Advance questions**:
    - What is a `fork`?
        +  A copy of a repository (repo) that sits in your account rather than the account from which you forked the data from.
    - What are the 2 ways to integrate changes from one branch to another?
        + `merge` and `rebase`.
    - What is `git rebase`?
        + Is to put your code at the top of the log, like rebasing all the other code and reorg the complete history.
    - How can you re-write the commit message?
        + `git commit --amend`
    - How can you check the changes inside a file tracked by `git`?
        + `git diff file-name`