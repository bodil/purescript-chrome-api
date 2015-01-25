module Chrome.Runtime
  ( LaunchData(..)
  , LaunchDataFileEntry(..)
  , FileEntry(..)
  , onLaunched
  , onRestarted
  ) where

import Chrome.Eff (Chrome(..))
import Chrome.Foreign
import Control.Monad.Eff
import Data.Either
import Data.Foreign
import Data.Foreign.NullOrUndefined
import Data.Foreign.Class
import Data.Maybe

type FileEntry = Foreign

data LaunchDataFileEntry = LaunchDataFileEntry
  { entry :: FileEntry
  , mimeType :: String
  }

instance isForeignLaunchDataFileEntry :: IsForeign LaunchDataFileEntry where
  read value = do
    entry <- readProp "entry" value
    mimeType <- readProp "type" value
    return $ LaunchDataFileEntry { entry: entry, mimeType: mimeType }

data LaunchData = LaunchData
  { id :: Maybe String
  , items :: [LaunchDataFileEntry]
  , url :: Maybe String
  , referrerUrl :: Maybe String
  , isKioskSession :: Boolean
  , source :: [String]
  }

instance isForeignLaunchData :: IsForeign LaunchData where
  read value = do
    id <- runNullOrUndefined <$> readProp "id" value
    items <- runNullOrUndefined <$> readProp "items" value
    url <- runNullOrUndefined <$> readProp "url" value
    referrerUrl <- runNullOrUndefined <$> readProp "referrerUrl" value
    isKioskSession <- readProp "isKioskSession" value
    source <- runNullOrUndefined <$> readProp "source" value
    return $ LaunchData
      { id: id
      , items: fromMaybe [] items
      , url: url
      , referrerUrl: referrerUrl
      , isKioskSession: isKioskSession
      , source: fromMaybe [] source
      }

foreign import onLaunched' """
  function onLaunched$prime(cb) {
    return function() {
      chrome.app.runtime.onLaunched.addListener(function(d) {
        cb(d)();
      });
    }
  }""" :: forall e. (Foreign -> Eff (chrome :: Chrome | e) Unit) -> Eff (chrome :: Chrome | e) Unit

onLaunched :: forall e. (LaunchData -> Eff (chrome :: Chrome | e) Unit) -> Eff (chrome :: Chrome | e) Unit
onLaunched cb = onLaunched' \d -> case read d of
  Left err -> rethrow err
  Right ld -> cb ld

foreign import onRestarted """
  function onRestarted(cb) {
    return function() {
      chrome.app.runtime.onRestarted.addListener(cb);
    }
  }""" :: forall e. Eff (chrome :: Chrome | e) Unit -> Eff (chrome :: Chrome | e) Unit
