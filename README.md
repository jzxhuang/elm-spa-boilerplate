# elm-spa-boilerplate

## ----- WORK IN PROGRESS -----

This project is a Work in Progress. It is not stable and subject to change at any time.

## Introduction

A simple, no-frills boilerplate for creating create robust Single Page Applications (SPAs) in Elm. [Check out the demo.](https://elm-spa-boilerplate.netlify.com/)

The goal of this project is to provide a minimalist starting point for your web application without any extra clutter. It does a lot of the "dirty work" for you, so you can get to coding right away. Easy to build on, yet powerful enough to support a fully-fledged application.

### Highlights

* Client-side routing that uses [pushState navigation](https://developer.mozilla.org/en-US/docs/Web/API/History_API) and the forward slash `/` as the path separator.
* Search Engine Optimization (SEO) friendly - unique Title for each page.
* Support for localStorage, with the necessary ports and JS handlers already initalized.
* Some helpful bash scripts to bundle and minimize files for production-ready code.
* Well-commented code!

### Inspiration

As I started working with Elm, one of the biggest things missing for me was a good boilerplate for web applications. The Elm Guide only [briefly touches upon](https://guide.elm-lang.org/webapps/navigation.html) navigation and routing for SPAs, and leaves most of the dirty work to be done by the reader. While there are some great examples of fully-fledged SPAs in Elm such as [Richard Feldman's RealWorld app](https://github.com/rtfeldman/elm-spa-example) and [the Elm Package site](https://github.com/elm/package.elm-lang.org), I found that if I tried to use one of these as a starting point, I had to clean the repo and remove all the extra files and features that I didn't need - it might take a couple hours before I could actually start writing my own code!

This project looks to fill in this void. It does a lot of the dirty work for you like routing, navigation, ports, and the file structure, but doesn't add any unecessary clutter on top of that. It's a great starting place whether you're trying Elm for the first time, or you're a seasoned Elm developer looking for a starting point for your next project.

## Getting Started

These instructions will walk you through getting the project up and running on your local system for development and testing. This project is designed to have no dependencies whatsoever, so you can use your favorite development tools as you like.

### Prerequisites

First off, you should clone the repo!. The only requirement is, well, Elm. This boilerplate is for Elm 0.19. If you don't have Elm yet, follow the [installation instructions here][elm install], or run `npm install -g elm`, although you should probably check out the [Elm guide][Elm guide] first before using this boilerplate!

### Development Build

All you need to do is compile the Elm code. From the root project directory, run:

```none
elm make src/Main.elm --output=elm.js
```

If you'd like to include the time-travelling debugger, add the `--debug` flag like so:

```none
elm make src/Main.elm --output=elm.js --debug
```

Check out the site by bringing up `index.html` in any local HTTP server, like [http-server][npm http server].

Note that because this is a SPA using Elm's `Browser.application`, you won't be able to open `index.html` directly - you will need an HTTP server. Additionally, Elm reactor also will **_not_** work for SPAs!

### Live Reload (elm-live)

I prefer using [elm-live][elm live] for Elm development, It's a a fast, lightweight dev server for Elm with live reload and support for client-side routing. You'll need [Node.js 6.0+][NodeJS]. Install using

```none
npm install -g elm-live
```

I've included a handy script for getting started. From the root project directory, just run:

```none
elm-live  src/Main.elm --port=8000 -u -- --output=elm.js --debug`
```

Check it out at [http://localhost:8000](http://localhost:8000)! Any changes you make in the source code will automatically be compiled and the page will be reloaded to show your changes!

I've included a script for running that command so you don't have to type it out every time. Run:

```none
cmd/dev
```

Another great option is [create-elm-app][create elm app], which includes everything elm-live has, plus [webpack]. I decided against including webpack in this boilerplate as it can be extra clutter for many people, but if you need webpack then definitely check out this tool! It should be very straightforward migrating this boilerplate to the file strucutre that create-elm-app generates.

### Production Build

Again, you can use whatever build tools you prefer. I've provided some bash scripts to point you towards best practices for the web, but if you know what you're doing, just ignore this and use your preferred build tools (although you should still read up on [effectively minifying Elm code using UglifyJS](https://guide.elm-lang.org/optimization/asset_size.html) if you haven't already.)

The build scripts use [Babel], [UglifyJS], [html-minifier][html minifier] and [PostCSS] to do the following:

* Transpile ES6+ to ES5 for maximum browser compatability
* Minifiy HTML/CSS/JS
* Auto-prefix CSS for maximum browser compatability

To use these scripts, first run

```none
npm install
```

Then, every time you would like to build, run the command

```none
cmd/prod
```

This will create production-ready files in a folder called _dist/_. If you're looking for some free web hosting options, I recommend checking out [Surge] or [Netlify].

## Cleaning the Repo

Ok, so I've made a big deal about there being no extra clutter, but you may have noticed that there are actually some files you might not need, depending on what development tools you're using! This section will list everything you can remove without breaking the project.

* First of all, you can delete `cmd/deploy-netlify`. This is used for hosting the demo site and is not needed, nor should you ever run it.
* If you aren't using elm-live, you can delete `cmd/dev`.
* If you aren't using the deployment scripts, you can delete `cmd/prod` and `cmd/minify`, as well as `package.json` and `package-lock.json`.

In summary, if you are you using your own tools, it's safe to delte the _cmd_ folder and _package.json_ and _package-lock.json_.

## How it Works

This is an advanced section that discusses some of the design choices made in creating this boilerplate, why I made these choices, and possible alternatives.

(To be completed...)

## Contributing

If you find any issues or you'd like to contribute, please feel free to open an issue on Github! I'd love to hear your feedback.

## Acknowledgements

A special thank you to [lucamug] for introducing me to Elm as well as inspiring me with his own [Elm SPA boilerplate](luca spa) which was written for Elm 0.18.

This project borrows some concepts from [elm/package.elm-lang.org][elm package site] and [rtfeldman/elm-spa-example][rtfeldman spa]. It uses [Babel], [UglifyJS], [html-minifier][html minifier] and [PostCSS] for building production files.

The demo site is hosted on [Netlify]. If you haven't heard of Netlify, I highly recommend checking it out!

## License

This project is licensed under the MIT License, see [LICENSE](./LICENSE) for details.

[elm install]: https://guide.elm-lang.org/install.html
[elm guide]: https://guide.elm-lang.org/
[elm live]: https://github.com/wking-io/elm-live
[elm package site]: https://github.com/elm/package.elm-lang.org
[rtfeldman spa]: https://github.com/rtfeldman/elm-spa-example
[create elm app]: https://github.com/halfzebra/create-elm-app
[npm http server]: https://www.npmjs.com/package/http-server
[NodeJS]: https://nodejs.org/en/
[webpack]: https://webpack.js.org/
[Babel]: https://babeljs.io/
[PostCSS]: https://postcss.org/
[UglifyJS]: https://github.com/mishoo/UglifyJS2
[html minifier]: https://www.npmjs.com/package/html-minifier
[Surge]: https://surge.sh/
[Netlify]: https://www.netlify.com/
[lucamug]: https://github.com/lucamug
[luca spa]: https://github.com/lucamug/elm-spa-boilerplate