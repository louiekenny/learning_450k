#learning_450k
#Overview
This will be written in the format of a blog style.
This will be a log of my progress in learning 450k analysis for my master's thesis.
I have picked up much of 450k analysis from random places. This will be a comprehensive analysis, where everything I know will be put here.

This work is analyzed on arch linux 4.4.5-1 running R 3.2.4 within Nvim 0.1.3 and the Nvim-R package 0.9.3

#Github
The first step is to learn github. This communication platform is vital to the efficient development of projects, specifically code. The first step is to create a github account. An SSH key should be generated at this point to link the device and your github account.

The openssh package needs to be installed on arch linux to use the ssh-keygen package.

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
git config --global user.name "username"
git config --global user.email "github account email"
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

##cloning or syncing with github
```
git clone *https link*
git pull
```
git pull will sync the github repo with your local files

#Data wrangling in R

##Dataframe practice
The gapminder dataset can be used as practice to learn basic data frame manipulation. This is important as most 450k work focuses on large tables. The practice exercise is taken from a [ubc course] (http://stat545.com/block006_care-feeding-data.html). I have attached my R [code] (https://github.com/louiekenny/learning_450k/blob/master/gapminder-practice.R) with comments after following the short ubc intro to data wrangling. You may also run my code and read my comments for a shortened summary of that intro.

##A note on factors
Understanding the differences between factors and other classes will help you avoid a lot of troubleshooting in the future. This [ubc course] (http://stat545.com/block014_factors.html) provides an indepth intro to understanding these differences and their value in platting and visualization of tables. I have attached my own R [code] (https://github.com/louiekenny/learning_450k/blob/master/factors-practice.R) with comments including mostly only the code portion of that course so that you may follow along.

#Introductory practice using a small expression dataset
This dataset is taken from a [ubc course] (https://github.com/STAT540-UBC/STAT540-UBC.github.io/blob/master/examples/photoRec/data/GSE4051_MINI.tsv) webpage. The dataset will be explored by the [seminar] (https://stat540-ubc.github.io/seminars/sm01b_gitIntro-basic-data-exploration.html) slides of the corresponding UBC 540 class.
