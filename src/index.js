import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const app = Elm.Main.init({
  flags: generateFlags(),
  node: document.getElementById('root')
});

// registerServiceWorker();

function generateFlags() {
  return {
    timeAppStarted: Date.now(),
    windowSize: { width: window.innerWidth, height: window.innerHeight }
  };
}