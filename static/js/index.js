/* 
  This file creates our Elm app, initializes it with flags and handles JavaScript interop through ports
*/

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
    localStorage: localStorage.getItem(storageName)
  };
}


// [To Elm] Send messages thorugh port on change of localStorage
window.addEventListener("storage", event => {
  if (event.storageArea === localStorage && event.key === storageName) {
    // console.log(event.newValue)
    app.ports.onLocalStorageChange.send(JSON.parse(event.newValue));
  }
});


// [From Elm] Set localStorage
app.ports.toLocalStorage.subscribe(data => {
  // console.log(data);
  localStorage.setItem(storageName, JSON.stringify(data));
  // app.ports.onLocalStorageChange.send(data);
});

// [From Elm] Clear localStorage
app.ports.clearLocalStorage.subscribe(() => {
  // console.log("clearing localStorage");
  localStorage.removeItem(storageName);
  // app.ports.onLocalStorageChange.send(null);
});

/* ----- NOTE: TO CONSIDER ----- 
  
  Notice how lines 39 and 46 are commented out. 
  It seems redundant to tell Elm about a change in localStorage that was initially triggered by Elm. 
  However, this may actually be useful! How?
  
  By doing this, we can synchronize state across multiple tabs!  For example, assuming that some sort of user credentials are stored in localStorage...
  if a user signs out on one tab, our app will receive the update in all other tabs and respond appropriately!
  
  However, one must be very careful in how you are handling changes in localStorage in each page. 
  There can be glitches caused by loops or a 'change' being received twice! 
  or that reason, I've left this 'redundancy' commented out. It shouldn't be needed for most simple applications

*/