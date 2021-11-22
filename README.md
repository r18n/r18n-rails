# R18n for Rails

[![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/r18n/r18n-rails?style=flat-square)](https://cirrus-ci.com/github/r18n/r18n-rails)
[![Codecov branch](https://img.shields.io/codecov/c/github/r18n/r18n-rails/main.svg?style=flat-square)](https://codecov.io/gh/r18n/r18n-rails)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/r18n/r18n-rails.svg?style=flat-square)](https://codeclimate.com/github/r18n/r18n-rails)
[![Depfu](https://img.shields.io/depfu/r18n/r18n-rails?style=flat-square)](https://depfu.com/repos/github/r18n/r18n-rails)
[![License](https://img.shields.io/github/license/r18n/r18n-rails.svg?style=flat-square)](LICENSE)
[![Gem](https://img.shields.io/gem/v/r18n-rails.svg?style=flat-square)](https://rubygems.org/gems/r18n-rails)

R18n-rails is a gem to add out-of-box [R18n](https://github.com/r18n/r18n) support to Rails I18n.

It is a wrapper for [R18n Rails API](https://github.com/r18n/r18n-rails-api)
and [R18n core](https://github.com/r18n/r18n-core) libraries.
See [R18n core documentation](https://github.com/r18n/r18n-core/blob/main/README.md)
for more information.

## Features

R18n for Rails is fully compatible with Rails I18n, and add extra features:

* Nice Ruby-style syntax.
* Filters.
* Model Translation (or any Ruby object).
* Auto-detect user locales.
* Flexible locales.
* Total flexibility.

See full features in [main README](https://github.com/r18n/r18n/blob/main/README.md).

## How To

1.  Add `r18n-rails` gem to your `Gemfile`:

     ```
    gem 'r18n-rails'
     ```
    Now R18n will auto-detect user locales.

2.  Define your way to set locale manually. R18n will find it in
    `params[:locale]` or `session[:locale]`. Best way is a put optional
    locale prefix to URLs:

    ```ruby
    match ':controller/:action'
    match ':locale/:controller/:action'
    ```

3.  Print available translations, to choose from them manually (and to help
    search engines):

    ```haml
    %ul
      - r18n.available_locales.each do |locale|
        %li
          %a( href="/#{locale.code}/" )= locale.title
    ```

4.  Translations in I18n format are stored in
    `config/locales/%{locale}.yml`:

    ```yaml
    en:
      user:
        name: "User name is %{name}"
        count:
          zero: "No users"
          one:  "One user"
          many: "%{count} users"
    ```
    Translations in R18n format go to `app/i18n/%{locale}.yml`:

    ```yaml
    user:
      name: User name is %1
      count: !!pl
        0: No users
        1: 1 user
        n: '%1 users'
    ```

5.  Use translated messages in views. You can use Rails I18n syntax:

    ```ruby
    t 'user.name',  name: 'John'
    t 'user.count', count: 5
    ```

    or R18n syntax:

    ```ruby
    t.user.name(name: 'John') # for Rails I18n named variables
    t.user.name('John')       # for R18n variables
    t.user.count(5)
    ```

6.  Print dates and numbers in user's tradition:

    ```ruby
    l Date.today, :standard #=> "2009-12-20"
    l Time.now,   :full     #=> "20th of December, 2009 12:00"
    l 1234.5                #=> "1,234.5"
    ```

7.  Translate models. You can use `R18n::Translated` mixin for any Ruby class,
    not only for ActiveRecord models

    1.  Add to migration columns for each of the supported locales, named as
        `%{name}_%{locale}`:

        ```ruby
        t.string :title_en
        t.string :title_ru

        t.string :text_en
        t.string :text_ru
        ```

    2.  Add `R18n::Translated` mixin to model:

        ```ruby
        class Post < ActiveRecord::Base
          include R18n::Translated
        ```

    3.  Call `translations` method in model with all columns to be translated:

        ```ruby
        translations :title, :text
        ```
        Now model will have virtual methods `title`, `text`, `title=`
        and `text=`, which will call `title_ru` or `title_en` and etc based
        on current user locales.

8.  Download translations for Rails system messages (validation, etc) from
    [svenfuchs/rails-i18n](https://github.com/svenfuchs/rails-i18n/tree/main/rails/locale)
    and put them to `config/locales/` (because them use Rails I18n format).

9.  Add your own translations filters to `app/i18n/filters.rb`:

    ```ruby
    R18n::Filters.add('gender') do |translation, config, user|
      translation[user.gender]
    end
    ```

    And use in translations:

    ```yaml
    log:
      signup: !!gender
        male: Он зарегистрировался
        female: Она зарегистрировалась
    ```

    and application:

    ```ruby
    t.log.signup(user)
    ```

## License

R18n is licensed under the GNU Lesser General Public License version 3.
You can read it in LICENSE file or in [www.gnu.org/licenses/lgpl-3.0.html](https://www.gnu.org/licenses/lgpl-3.0.html).

## Author

Andrey “A.I.” Sitnik [andrey@sitnik.ru](mailto:andrey@sitnik.ru)
