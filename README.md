# wtf-bot

A Flask application that powers the /wtf Slack command. 
Inspired by the VA bot of same name [HERE](https://github.com/department-of-veterans-affairs/wtf-bot) of similar functionality. 
Configured for deployment on [DigitalOcean](https://www.digitalocean.com/). 
Relies on [this acronym list](https://github.com/elliottgreen/slack-wtf-bot-acronyms).

## Local development
__Tested in Arch Linux and WSL2 (Kali)__

Clone this repo.

```
$ git clone https://github.com/elliottgreen/slack-wtf-bot.git
$ cd slack-wtf-bot
```

### Create and configure virtual environment.

***nix**

 ```
  $ make python-install
  $ source env/bin/activate
 ```

**Run tests.**

```
$ make test
```
 ** Clean up, after tests.**

 ```
 $ make deep clean
 ```

## Run the server locally

### Set up environment variables


```
$ export FLASK_APP=`pwd`/app/wtf.py
$ export FLASK_DEBUG=1
$ export SLACK_TOKENS={comma separated tokens to be defined by you}
$ export DATA_URL=https://raw.githubusercontent.com/elliottgreen/slack-wtf-bot-acronyms/main/acronyms.csv
```

## Bugs, feature requests, or contributions

Open an [Issue](https://github.com/elliottgreen/slack-wtf-bot/issues). Pull requests welcome.
