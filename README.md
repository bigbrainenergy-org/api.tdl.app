# README

## Dev Container
### Prerequisites
Ensure you have the Dev Containers VS Code extension installed.
### Launching the Project
Open the repo in Visual Studio Code. If prompted, click "Open Dev Container." Otherwise, open the command pallete with Ctrl+Shift+P, find and select the option "Dev Containers: Rebuild and Reopen in Container"

## Manual Installation
### Installation
#### Prerequisites
`rvm` [Click here for ArchWiki](https://wiki.archlinux.org/title/RVM#Installing_RVM)
`postgres` [Click here for ArchWiki](https://wiki.archlinux.org/title/PostgreSQL)

1. `git clone git@github.com:bigbrainenergy-llc/api.tdl.app`
2. `rvm install 3.0.1`
3. `rvm use 3.0.1`
4. `gem install rails`
5. `bundle install`
6. `rails db:create db:migrate db:seed` or to recreate: `rails db:drop db:create db:migrate db:seed`
7. `rails s` to launch server


## TODO
- [ ] Validate README
- [ ] Create guide on correctly configuring PATH using various shells
- [ ] Note gnome-terminal deviations from default config (login shell)
- [ ] [Use UUID and other goodies like inet columns](https://guides.rubyonrails.org/active_record_postgresql.html)
- [ ] Add support for detected breached/weak passwords (have i been pwned)

## Commands

* `RAILS_ENV=test rake rswag`
  * Generates specs from OpenAPI docs

## Troubleshooting

Can't connect to GitHub when fetching dependencies in the devcontainer? Turn off wireguard. (wtf?)
**If sorcery-rework doesn't download, also try deleting vendor/bundle (clearing gem cache)**
> fatal: --unshallow on a complete repository does not make sense

Same thing, delete `vendor/bundle`