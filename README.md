# critical-path-css-rails [![Code Climate](https://codeclimate.com/github/mudbugmedia/critical-path-css-rails/badges/gpa.svg)](https://codeclimate.com/github/mudbugmedia/critical-path-css-rails)

Only load the CSS you need for the initial viewport in Rails!

This gem give you the ability to load only the CSS you *need* on an initial page view. This gives you blazin' fast rending as there's no initial network call to grab your application's CSS.

This gem assumes that you'll load the rest of the CSS asyncronously. At the moment, the suggested way is to use the [loadcss-rails](https://github.com/michael-misshore/loadcss-rails) gem.

This gem uses [PhantomJS](https://github.com/colszowka/phantomjs-gem) and [Penthouse](https://github.com/pocketjoso/penthouse) to generate the critical CSS.


## Installation

Add `critical-path-css-rails` to your Gemfile:

```
gem 'critical-path-css-rails', '~> 0.1.0'
```

Download and install by running:

```
bundle install
```

Create the rake task that will generate your critical CSS

```
rails generator critical_path_css:install
```

This adds the following file:

* `lib/tasks/critical_path_css.rake`


## Usage

First, you'll need to configue a few variables in the rake task: `lib/tasks/critical_path_css.rake`

* `@base_url`: Change the url's here to match your Production and Development base URL, respectively.
* `@routes`: List the routes that you would like to generate the critical CSS for. (i.e. /resources, /resources/show/1, etc.)
* `@main_css_path`: Inside of the generate task, you'll need to define the path to the application's main CSS. The gem assumes your CSS lives in `RAILS_ROOT/public`. If your main CSS file is in `RAILS_ROOT/public/assets/main.css`, you would set the variable to `/assets/main.css`.


Before generating the CSS, ensure that your application is running (viewable from a browser) and the main CSS file exists. Then in a separate tab, run the rake task to generate the critical CSS.

If your main CSS file does not already exist, and you are using the Asset Pipeline, generate the main CSS file.
```
rake assets:precompile
```
Generate the critical path CSS:
```
rake critical_path_css:generate
```


To load the generated critical CSS into your layout, in the head tag, insert:

```html
<style>
  <%= CriticalPathCss.fetch(request.path) %>
</style>
```

A simple example using loadcss-rails looks like:

```html
<style>
    <%= CriticalPathCss.fetch(request.path) %>
</style>
<script>
    loadCSS("<%= stylesheet_path('application') %>");
</script>
<noscript>
    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true %>
</noscript>
```


## Versions

The critical-path-css-rails gem follows these version guidelines:

```
patch version bump = updates to critical-path-css-rails and patch-level updates to Penthouse and PhantomJS
minor version bump = minor-level updates to critical-path-css-rails, Penthouse, and PhantomJS
major version bump = major-level updates to critical-path-css-rails, Penthouse, PhantomJS, and updates to Rails which may be backwards-incompatible
```

## Contributing

Feel free to open an issue ticket if you find something that could be improved. A couple notes:

* If the Penthouse.js script is outdated (i.e. maybe a new version of Penthouse.js was released yesterday), feel free to open an issue and prod us to get that thing updated. However, for security reasons, we won't be accepting pull requests with updated Penthouse.js script.

Copyright Mudbug Media and Michael Misshore, released under the MIT License.