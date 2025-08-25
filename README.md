# tamandua

schlorping appointments for you since 2025

![the schlorper](https://github.com/user-attachments/assets/6d51add6-eedd-438f-a16b-f1c5b0162633)

(aka: what unmedicated adhd does to a mf)

### Installation

1. Pull this repo (obvs lol)
2. Install required version of Ruby as per Gemfile. Use rbenv + ruby-build, mise, etc...
3. Either export these env variables on your shell, or create a .env file in the tamandua directory like this:

```sh
WEBHOOK_URL=https://discord.com/api/webhooks/channel_id/secret
USER_ID="enable developer settings on discord + right click your username + copy userid"
```

4. Automate running init.sh with your favourite tool. It assumes you're using mise, feel free to use your favourite ruby ver manager

### Limitations

- Won't remember previous runs, so you'll get spammed all the time there's a new appointment until it's taken
- Very rigid validations, it'll probably break if they change their format
- No good error handling. Good luck debugging soldier
- uses global variables. ugly. disgusting. ugh. but icba to write something proper
- its written in ruby
