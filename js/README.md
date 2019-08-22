# CleanLocalization
## Simple and minimalistic pure JS localization
```js
import { CleanLocalizationClient } from "@tarvit/clean_localization";

// sample localization json
data = {"user.name": "User name", "header.title": "Hi %{name}!"};

// Populate localization db.
CleanLocalizationClient.db.data = data;

// Use client
const t = require("@tarvit/clean_localization").CleanLocalizationClient.t;
t("user.name") //=> "User name"
t("header.title", { name: "John Snow" }) // => "Hi John Snow!"

```
# Commands for development
## install dependencies
$ yarn

## test
$ yarn test

## build
$ yarn build

## release
$ npm publish
