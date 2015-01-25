module Chrome.Window
  ( createWindow
  , createWindowOptions
  , CreateWindowOptions(..)
  , BoundsSpecification(..)
  , bounds
  ) where

import Chrome.Eff (Chrome(..))
import Chrome.Foreign
import Control.Monad.Eff
import Data.Maybe
import Data.Foreign

type BoundsSpecification =
  { left :: Maybe Number
  , top :: Maybe Number
  , width :: Maybe Number
  , height :: Maybe Number
  , minWidth :: Maybe Number
  , minHeight :: Maybe Number
  , maxWidth :: Maybe Number
  , maxHeight :: Maybe Number
  }

bounds :: BoundsSpecification
bounds =
  { left: Nothing
  , top: Nothing
  , width: Nothing
  , height: Nothing
  , minWidth: Nothing
  , minHeight: Nothing
  , maxWidth: Nothing
  , maxHeight: Nothing
  }

type CreateWindowOptions =
  { id :: Maybe String
  , innerBounds :: Maybe BoundsSpecification
  , outerBounds :: Maybe BoundsSpecification
  , frame :: Maybe String
  , state :: Maybe String
  , hidden :: Boolean
  , resizable :: Boolean
  , alwaysOnTop :: Boolean
  , focused :: Boolean
  }

createWindowOptions :: CreateWindowOptions
createWindowOptions =
  { id: Nothing
  , innerBounds: Nothing
  , outerBounds: Nothing
  , frame: Nothing
  , state: Nothing
  , hidden: false
  , resizable: true
  , alwaysOnTop: false
  , focused: true
  }

foreign import createWindow' """
  function createWindow$prime(url) {
    return function(opts) {
      return function() {
        return chrome.app.window.create(url, opts);
      }
    }
  }""" :: forall e. String -> Foreign -> Eff (chrome :: Chrome | e) Unit

mkBoundsSpec :: BoundsSpecification -> Foreign
mkBoundsSpec b = toForeign
  { left: nullableCoerce b.left
  , top: nullableCoerce b.top
  , width: nullableCoerce b.width
  , height: nullableCoerce b.height
  , minWidth: nullableCoerce b.minWidth
  , minHeight: nullableCoerce b.minHeight
  , maxWidth: nullableCoerce b.maxWidth
  , maxHeight: nullableCoerce b.maxHeight
  }

makeCreateWindowOptions :: CreateWindowOptions -> Foreign
makeCreateWindowOptions opts = toForeign
  { id: nullableCoerce opts.id
  , innerBounds: nullableTransform mkBoundsSpec opts.innerBounds
  , outerBounds: nullableTransform mkBoundsSpec opts.outerBounds
  , frame: nullableCoerce opts.frame
  , state: nullableCoerce opts.state
  , hidden: opts.hidden
  , resizable: opts.resizable
  , alwaysOnTop: opts.alwaysOnTop
  , focused: opts.focused
  }

createWindow :: forall e. String -> CreateWindowOptions -> Eff (chrome :: Chrome | e) Unit
createWindow url opts = createWindow' url (makeCreateWindowOptions opts)
