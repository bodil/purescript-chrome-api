module Chrome.Foreign
  ( rethrow
  , nullableCoerce
  , nullableTransform
  , nullableListCoerce
  ) where

import Control.Monad.Eff
import Data.Foreign (toForeign, Foreign(..), ForeignError(..))
import Data.Maybe (Maybe(..))

foreign import rethrow """
  function rethrow(err) {
    throw err;
  }""" :: forall e. ForeignError -> Eff e Unit

foreign import nullValue "var nullValue = null;" :: Foreign

nullableTransform :: forall a b. (a -> b) -> Maybe a -> Foreign
nullableTransform _ Nothing = nullValue
nullableTransform f (Just a) = toForeign (f a)

nullableCoerce :: forall a. Maybe a -> Foreign
nullableCoerce = nullableTransform id

nullableListCoerce :: forall a. [a] -> Foreign
nullableListCoerce [] = nullValue
nullableListCoerce as = toForeign as
