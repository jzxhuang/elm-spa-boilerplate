// CONFIG
const storageName = "elm-spa-boilerplate" // key in localStorage

const app = Elm.Main.init({
  flags: generateFlags(),
  node: document.getElementById('elm')
});


// Generate flags to send to our Elm app on intialization
function generateFlags() {
  return {
    timeAppStarted: Date.now(),
    windowSize: {
      width: window.innerWidth,
      height: window.innerHeight
    },
    localStorage: JSON.parse(localStorage.getItem(storageName)) || null
  };
}

// --- PORTS ---

// [To Elm] Send messages thorugh port on change of localStorage
if (app.ports.onLocalStorageChange) {
  window.addEventListener("storage", event => {
    if (event.storageArea === localStorage && event.key === storageName) {
      // console.log(event.newValue)
      app.ports.onLocalStorageChange.send(JSON.parse(event.newValue) || null);
    }
  });
}


// [From Elm] Set localStorage
if (app.ports.toLocalSotrageChange) {
  app.ports.toLocalStorage.subscribe(data => {
    // console.log(data);
    localStorage.setItem(storageName, JSON.stringify(data));
    // app.ports.onLocalStorageChange.send(data);
  });
}


// [From Elm] Clear localStorage
if (app.ports.clearLocalStorage) {
  app.ports.clearLocalStorage.subscribe(() => {
    // console.log("clearing localStorage");
    localStorage.removeItem(storageName);
    // app.ports.onLocalStorageChange.send(null);
  });
}

/* ----- NOTE: TO CONSIDER ----- 
  
  Notice how lines 43 and 50 are commented out. 
  It seems redundant to tell Elm about a change in localStorage that was initially triggered by Elm. 
  However, this may actually be useful! How?
  
  By doing this, we can synchronize state across multiple tabs!  For example, assuming that some sort of user credentials are stored in localStorage...
  if a user signs out on one tab, and we clear the localStorage through Elm in that tab, our app will receive the update in all other tabs and respond appropriately if we send this 'redundant' message!
  
  However, one must be very careful in how you handle changes in localStorage in each page. 
  You might end up creating an infinite loop of messages being passed, or responding to a change in localStorage twice
  or that reason, I've left this 'redundancy' commented out. It shouldn't be needed for most simple applications

*/