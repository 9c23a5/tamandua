# tamandua

schlorping appointments for you since 2025

![the schlorper](https://github.com/user-attachments/assets/6d51add6-eedd-438f-a16b-f1c5b0162633)

### Installation

#### Unattended setup (recommended)

The intended way to use tamandua is to run it periodically via systemd timers or cron. I recommend systemd since it also handles ENVs nicely for you.

Initial setup in your server:

```sh
# create a new user for this service
sudo useradd --system --no-create-home --shell /usr/sbin/nologin tamandua

# copy systemd service, timer, and env configuration
git clone https://github.com/9c23a5/tamandua.git && cd tamandua
sudo cp deploy/tamandua.{service,timer} /etc/systemd/system/
sudo mkdir -p /etc/tamandua/env
sudo cp env.example /etc/tamandua/env  # then fill in values
sudo chmod 600 /etc/tamandua/env

# enable timer
sudo systemctl daemon-reload
sudo systemctl enable --now tamandua.timer
sudo systemctl start tamandua.service # test if it works
```

And on your fork's Github Actions Secrets settings, fill in these:

- `DEPLOY_SSH_KEY`
- `SSH_HOST`
- `SSH_USER`

Make sure they're secrets and not variables!

Next CI run should push the binary to your server. Ensure that CI step `upload_artifact` generates the artifact for your platform.

#### Nightly builds

Every push generates artifacts for 90 days. I don't recommend using these, they're not meant to be release binaries, and I don't plan on generating releases

You can check for the latest artifacts, if available, [here](https://nightly.link/9c23a5/tamandua/workflows/test_and_upload_artifact/main)

#### Build from source

1. Pull this repo
2. Install Crystal: https://crystal-lang.org/install (required version available in shard.yml)
3. Build release binary:

```sh
make release
# Or if you wanna cross-compile
docker buildx build --platform linux/amd64 --output type=local,dest=./out/amd64 .
# repalce linux/amd64 with your platform
```

If you want a build with debugger symbols, remove `--no-debug`. Static linking only works in Alpine linux, therefore Docker is required for cross-compiling, see [Crystal docs](https://crystal-lang.org/reference/1.19/guides/ci/gh-actions.html#publishing-executables)

4. Export these env variables on your shell, they're required at runtime:

```sh
export WEBHOOK_URL=https://discord.com/api/webhooks/channel_id/secret
export USER_ID="enable developer settings on discord + right click your username + copy userid"
```

5. schlorp your appointments:

```sh
./tamandua
```

### Todo

- Tests
- Retry temporary network errors (Askelpios loves to time out at 10am)
- Remember appointments and only notify when a new appointment is available or when one has been taken
