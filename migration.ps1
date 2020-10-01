#run from Powershell as administrator
#Not able to replicate the initial repository creation step you can do from user interface
#in AzureDevOps via a scripted command. So the below repos were manaully created empty and then filled in.

#List of project's repositories to push to Azure DevOps
$RepositoriesToUpdate = @(
"sourcerepositorytomove");


foreach($repo in $RepositoriesToUpdate){
    $localdir = "D:\AzureMoveThemRepos";
    $REPONAME = $repo;
    #Access token for target Azure repos
    $PAT="xxxxxx";
    $REPO_URL="https://project@dev.azure.com/org/project/_git/{0}" -f $REPONAME;
    $REMOTE_ORIGIN="https://CodePAT:{1}@dev.azure.com/org/project/_git/{0}" -f $REPONAME, $PAT;
    $SOURCE_REPO="https://sourceorg.visualstudio.com/DefaultCollection/project/_git/{0}" -f $REPONAME;
    If(!(Test-Path $localdir))
    {
        New-Item -ItemType Directory -Force -Path $localdir
    }
    cd $localdir
      
    try {
        git clone $SOURCE_REPO --no-checkout --branch master
        cd $REPONAME
        git remote set-url origin $REMOTE_ORIGIN
        git push origin master 
    } catch {}
    cd $localdir
    Remove-Item $localdir'\'$REPONAME -Recurse -Force
}

