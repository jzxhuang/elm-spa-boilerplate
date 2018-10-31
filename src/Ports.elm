port module Ports exposing (clearLocalStorage, onLocalStorageChange, toLocalStorage)

import Json.Encode
import Type.LocalStorage



-- Listener for change to localStorage


port onLocalStorageChange : (Json.Encode.Value -> msg) -> Sub msg



-- Set localStorage


port toLocalStorage : Type.LocalStorage.LocalStorage -> Cmd msg



-- Clear localStorage


port clearLocalStorage : () -> Cmd msg
