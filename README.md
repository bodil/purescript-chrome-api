# purescript-chrome-api

PureScript bindings for the [Chrome Platform APIs](https://developer.chrome.com/apps/api_index).

## Quick Start

This is how the background script for a Chrome app that just opens the
file `window.html` in a new window would look like.

```purescript
module Demo.TheOpenAWindowApp where

import Chrome.Runtime
import Chrome.Window
import Data.Maybe

main = onLaunched \launchData -> do
  createWindow "window.html" $ createWindowOptions
    { id = "omg it is a window"
    , innerBounds = Just $ bounds { width = Just 640, height = Just 480 }
    }
  return unit
```

## License

Copyright 2014 Bodil Stokke

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this program. If not, see
<http://www.gnu.org/licenses/>.
