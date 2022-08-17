# Yuri #

[@zarkiel](https://github.com/zarkiel) - Zarkiel
### Introduction ###

> Yuri is a web environment that allows to you manage your project from the easy way

### Minimum Requirements ###

- Rails 3.2.x

### Installation ##
You can install the gem from rubygems by using the next command:
```bash
gem install yuri
```
Or simply add the gem in your gemfile
```bash
gem 'yuri'
```
and run
```bash
bundle install
```

### Usage ###
Once installed, add the following route to mount Yuri in your project.
```ruby
mount Yuri::Engine, :at => '/yuri'
```
Run your server and open the next url.
```bash
http://localhost:3000/yuri
```
