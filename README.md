# Siel #

[@zarkiel](https://github.com/zarkiel) - Zarkiel
### Introduction ###

> Siel is a web environment that allows to you manage your project from the easy way

### Minimum Requirements ###

- Rails 3.2.x

### Installation ##
You can install the gem from rubygems by using the next command:
```bash
gem install siel
```
Or simply add the gem in your gemfile
```bash
gem 'siel'
```
and run
```bash
bundle install
```

### Usage ###
Once installed, add the following route to mount Yuri in your project.
```ruby
mount Siel::Engine, :at => '/siel'
```
Run your server and open the next url.
```bash
http://localhost:3000/yuri
```
