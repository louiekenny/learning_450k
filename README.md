#learning_450k
#Overview
This will be written in the format of a blog style.
This will be a log of my progress in learning 450k analysis for my master's thesis.
I have picked up much of 450k analysis from random places. This will be a comprehensive analysis, where everything I know will be put here.

My development and analysis platform is arch linux 4.4.5-1 running R 3.2.4 within Nvim 0.1.3 and the Nvim-R package 0.9.3

#Github
The first step is to learn github. This communication platform is vital to the efficient development of projects, specifically code. The first step is to create a github account. An SSH key should be generated at this point to link the device and your github account.

The openssh package needs to be installed on arch linux.

```
mkdir ~/.ssh
cd ~/.ssh
ssh-keygen -t rsa
```

Choose a file name and the file created \*.pub contains the key used for adding to the github account settings.


##setting up github
Create a new local folder intended to use for a new github repo
```
mkdir learning_450k  
cd learning_450k  
git init  
```

##adding files to github
```
git add $file   
git commit -m "$message"  
git remote add remote add origin "$github_account" #if origin master needs to be changed   
git push -u origin master  
```
##checking status of github
```
git status  
git log  
git log --oneline  
```
