## Ubuntu on WSL
`mix ecto.create` ain't working OOTB for me. Did this instead:
```sh
sudo -i -u postgres
createuser --createdb --pwprompt --no-createrole --no-superuser url_shortener
```
Enter `password` as the password (***dev only!***)
```sh
exit
```
Finally
```sh
mix ecto.create
```
To enable live reloading, install `inotify-tools`:
```sh
sudo apt install inotify-tools
```
