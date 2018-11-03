# elm-spa-boilerplate

## ----- WORK IN PROGRESS -----

This project is a Work in Progress. It is not stable and subject to change at any time.

## Introduction

A simple, no-frills boilerplate for creating create robust Single Page Applications (SPAs) in Elm - created for Elm 0.19. [Check out the demo!](https://elm-spa-boilerplate.netlify.com/)

All the dirty work is done for you, so you can get to coding right away. No extra clutter. No unnecessary files. Just clone, compile and get straight to work.

### Highlights

* Client-side routing that uses [pushState navigation](https://developer.mozilla.org/en-US/docs/Web/API/History_API) and the forward slash `/` as the path separator. Handle 404 pages however you'd like.
* Search Engine Optimization (SEO) friendly - unique title for each page.
* Support for localStorage, with the required Elm ports and JS handlers already initalized.
* No dependencies or forced build tools. Use your favourite tools at will!
* File structure that follows and enforces good coding practices in Elm.
* Webpack ready.
* Well-commented code!

## Getting Started

These instructions will walk you through getting the project up and running on your local system for development and testing.

### Prerequisites

First off, you should clone the repo!

Of course, you'll need Elm - if you don't have Elm yet, follow the [installation instructions here][elm install], or run `npm install -g elm`. That being said, if you're completely new to Elm, you should probably check out the [Elm guide][Elm guide] before using this boilerplate!

`elm-spa-boilerplate` uses [create-elm-app][create elm app] for development and production builds. I've found that `create-elm-app` is the only Elm development server that fully supports SPAs.

Assuming you have [Node.js 8.0+][nodejs], install `create-elm-app` by running

```none
npm install -g create-elm-app
```

### Development Build

From the root project directory, run

```none
elm-app start
```

Then, go to [http://localhost:3000]([http://localhost:3000]) to see the site in action!

As you make changes in your code, the site will be reloaded automatically so you can see your changes in real time.

_Note 1_: If you have your own dev server that you'd like to use instead of create-elm-app, follow the instructions in the comments at the top of `./index.html`.

_Note 2_: `elm reactor` will **_not_** work for SPAs!

### Production Build

Build minified, bundled production ready files by running

```none
elm-app build
```

This will create the `build/` folder with production ready files.

If you're looking for some free web hosting options, I recommend checking out [Surge] or [Netlify].

## Usage

### Adding and Removing Pages

### Routing with Hashes

### JavaScript Interop (Ports)

Add your handlers for ports in `src/index.js` (or create a new file if you'd like). Define Elm ports in `src/Ports.elm`. This file is imported in `src/Main.elm`, and can be imported in other pages as needed. Read more about JavaScript interop with ports in Elm [here][elm ports]

### Configuration

For most of your configuration needs, like adding images, setting up environment variables, using a CSS Preprocessor or elm-css, it's done by following the [create-elm-app docs][create elm app docs].

### Service Workers

### Cleaning the Repo

*TODO*
Ok, so I've made a big deal about there being no extra clutter, but you may have noticed that there are actually some files you might not need, depending on what development tools you're using! This section will list everything you can remove without breaking the project.

* You can delete `package.json` and `package-lock.json`. There is no need to run `npm install`, but if you did, you can also delete the `node_modules` folder. These files are only used for deploying the demo site to my web hosting service!
* Delete `netlify.toml`. This is also used for deploying my demo site.
* If you're using create-elm-app, delte `index.html` from the repo's root. Be careful - make sure you delete the `index.html` at the root and not the one in the `public/` folder!

## How it Works

This is an advanced section that discusses some of the design choices made in creating this boilerplate, why I made these choices, and possible alternatives.

### Inspiration

As I started working with Elm, one of the biggest things missing for me was a good boilerplate for SPAs. The Elm Guide only [briefly touches upon](https://guide.elm-lang.org/webapps/navigation.html) navigation and routing for SPAs, and leaves most of the dirty work to be done by the reader. While there are some great examples of fully-fledged SPAs in Elm such as [Richard Feldman's RealWorld app](https://github.com/rtfeldman/elm-spa-example) and [the Elm Package site](https://github.com/elm/package.elm-lang.org), I found that if I tried to use one of these as a starting point, I had to clean the repo and remove all the extra files and features that I didn't need - it might take a couple hours before I could actually start writing my own code!

`elm-spa-boilerplate` looks to fill in this void. It includes all the necessary features like routing, navigation, localStorage and the file structure, but doesn't add any unecessary clutter on top of that. Whether you're trying Elm for the first time or you're a seasoned Elm developer, this boilerplate is a great starting point for your next Elm project.

### Design Choices

(To be completed...)

## Contributing

Found an issue? Think there's an improvement to be made? Please feel free to open an issue on Github! I'd love to hear your thoughts and feedback.

## Acknowledgements

A special thank you to [lucamug] for introducing me to Elm as well as inspiring me with his own [Elm SPA boilerplate](luca spa) which was written for Elm 0.18.

This project borrows some concepts from [elm/package.elm-lang.org][elm package site] and [rtfeldman/elm-spa-example][rtfeldman spa]. It uses [create-elm-app][create elm app] for development and production.

The demo site is hosted on [Netlify]. If you haven't heard of Netlify, I highly recommend checking it out!

## License

This project is licensed under the MIT License, see [LICENSE](./LICENSE) for details.

[elm install]: https://guide.elm-lang.org/install.html
[elm guide]: https://guide.elm-lang.org/
[elm ports]: https://guide.elm-lang.org/interop/ports.html
[elm live]: https://github.com/wking-io/elm-live
[elm package site]: https://github.com/elm/package.elm-lang.org
[rtfeldman spa]: https://github.com/rtfeldman/elm-spa-example
[create elm app]: https://github.com/halfzebra/create-elm-app
[create elm app docs]: https://github.com/halfzebra/create-elm-app/blob/master/template/README.md
[npm http server]: https://www.npmjs.com/package/http-server
[NodeJS]: https://nodejs.org/en/
[webpack]: https://webpack.js.org/
[Surge]: https://surge.sh/
[Netlify]: https://www.netlify.com/
[lucamug]: https://github.com/lucamug
[luca spa]: https://github.com/lucamug/elm-spa-boilerplate