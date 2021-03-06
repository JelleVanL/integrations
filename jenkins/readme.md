# SWEAGLE Integration to JENKINS

DESCRIPTION

This folder provides examples of configuration to include SWEAGLE into a JENKINS job.
SWEAGLE will become the configuration data approval gate before you build your application and deploy it to your various environments.
SWEAGLE will also fill the tokens with the values linked to deployment context (targeted environment, release, or component, ...)

Several options are available and described here to use SWEAGLE with Jenkins pipelines.
You can
- rely on shell scripts (available for linux or windows),
- use official SWEAGLE Jenkins plug-In,
- or use direct REST calls in Jenkins groovy script.


JENKINS SWEAGLE OFFICIAL PLUG-IN

Jenkins official plug-in is available from here:
https://plugins.jenkins.io/sweagle


PRE-REQUISITES

For jenkinsfile-shell-(declarative or scripted), you should use the scripts provided here with the scripts provided under the linux or windows directory.
Note: Script "uploadDirToSweagle" requires no space in the name of your jenkins project.

For jenkinsfile-plugin, you should first install SWEAGLE official plugin on your Jenkins.


INSTALLATION

For jenkinsfile-shell-declarative or jenkinsfiles-shell-scripted
1. Put all linux or windows SWEAGLE shell scripts into one folder of your jenkins job workspace (for example in "/sweagle_scripts") or your git repository (if you are using jenkins pipeline with git plugins)
2. Open the "sweagle.env" script and put your values for SWEAGLE tenant, API token, and scripts path (for ex: "./sweagle_scripts")
3. In Jenkins:
    - if you use classic steps/jobs approach, configure your project and add Shell steps in order to use SWEAGLE scripts. Recommended approach is:
        - First step, upload your config files to SWEAGLE
        - Second step, check configuration status from SWEAGLE
        - Third step (optional), if you use Sweagle tokens, add a last step to get the configuration files from SWEAGLE
        - Then, do your build
     - if you use pipelines approach, 2 samples jenkins file are provided here with content defined below, simply copy, paste and adapt the stages you need in your own pipeline file

By default, SWEAGLE scripts exits with 1 in case of issues, which will fail the JENKINS job or pipeline.

That's all !

CONTENT

/jenkinsfile-directAPI-groovy         : Sample JENKINS pipeline file using groovy script to call SWEAGLE APIs directly from pipeline script (no prerequisites)

/jenkinsfile-plugin         : Sample JENKINS pipeline file using SWEAGLE plugin

/jenkinsfile-shell-declarative         : Sample JENKINS declarative pipeline file using shell scripts, supported only since Jenkins v2.15

/jenkinsfile-shell-scripted         : Sample JENKINS scripted pipeline file using shell script (groovy style), supported since Jenkins 2.0

In all scripts, stages are similar:
- Stage "uploadConfig" is used to upload config files to SWEAGLE
    - Call input:
        - CONFIG_DIR = Config file or directory containing all files to upload to SWEAGLE
        - SWEAGLE_PATH = Path in Data Model where you want to put your configuration data

- Stage "CheckConfig" is used to ask Sweagle to check your configuration
    - In case the configuration is wrong, SWEAGLE will return an exit code <> 0 that will freeze the pipeline
    - Call input:
        - SWEAGLE_MDS = Sweagle MDS to check
        - SWEAGLE_VALIDATORS = SWEAGLE custom validators used to check configuration (as many as needed separated by spaces)

- Stage "DownloadConfig" is used to retrieve latest valid configuration data before deployment
    - SWEAGLE will also fill tokens values (if any)
