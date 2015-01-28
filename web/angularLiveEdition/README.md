README
===


# Installations 

### `angular-xeditable`
Follow instructions [on the main page](http://vitalets.github.io/angular-xeditable/)

`bower install angular-xeditable` and include in `index.html`

```
<link href="bower_components/angular-xeditable/dist/css/xeditable.css" rel="stylesheet">
<script src="bower_components/angular-xeditable/dist/js/xeditable.js"></script>
```

### `ngResource` module
`ngResource` provides interaction support with RESTful services via the `$resource` service. 

`bower install angular-resource`

which creates the following dilemmas during the installation... (and I chose:)

```
Unable to find a suitable version for angular, please choose one:
    1) angular#~1.2.0 which resolved to 1.2.28 and is required by live-edition
    2) angular#1.2.28 which resolved to 1.2.28 and is required by angular-resource#1.2.28
    3) angular#1.3.11 which resolved to 1.3.11 and is required by angular-resource#1.3.11
    4) angular#~1.x which resolved to 1.3.11 and is required by angular-xeditable#0.1.8Prefix the choice with ! to persist it to bower.json

? Answer:: 3!
bower angular               resolution Saved angular#1.3.11 as resolution

Unable to find a suitable version for angular-resource, please choose one:
    1) angular-resource#~1.2.0 which resolved to 1.2.28 and is required by live-edition
    2) angular-resource#~1.3.11 which resolved to 1.3.11Prefix the choice with ! to persist it to bower.json

? Answer:: 2!
bower angular-resource      resolution Saved angular-resource#~1.3.11 as resolution
bower angular#1.3.11           install angular#1.3.11
bower angular-resource#~1.3.11 install angular-resource#1.3.11
```

### Fake online REST API for testing and prototyping: `JSONPlaceholder` 
[check here documentation](https://github.com/typicode/jsonplaceholder)

To use it online, for example: `http://jsonplaceholder.typicode.com/posts`

But, to install and use it locally:

    $ npm install jsonplaceholder
    $ Run: node node_modules/jsonplaceholder/cli.js

`jsonplaceholder` is based on [json-server](https://github.com/typicode/json-server), a REST API mocking based on plain JSON.