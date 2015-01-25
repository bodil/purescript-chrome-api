# Module Documentation

## Module Chrome.Eff

### Types


    data Chrome :: !


## Module Chrome.Foreign

### Values


    nullableCoerce :: forall a. Maybe a -> Foreign


    nullableListCoerce :: forall a. [a] -> Foreign


    nullableTransform :: forall a b. (a -> b) -> Maybe a -> Foreign


    rethrow :: forall e. ForeignError -> Eff e Unit


## Module Chrome.Runtime

### Types


    type FileEntry = Foreign


    data LaunchData where
      LaunchData :: { source :: [String], isKioskSession :: Boolean, referrerUrl :: Maybe String, url :: Maybe String, items :: [LaunchDataFileEntry], id :: Maybe String } -> LaunchData


    data LaunchDataFileEntry where
      LaunchDataFileEntry :: { mimeType :: String, entry :: FileEntry } -> LaunchDataFileEntry


### Type Class Instances


    instance isForeignLaunchData :: IsForeign LaunchData


    instance isForeignLaunchDataFileEntry :: IsForeign LaunchDataFileEntry


### Values


    onLaunched :: forall e. (LaunchData -> Eff (chrome :: Chrome | e) Unit) -> Eff (chrome :: Chrome | e) Unit


    onRestarted :: forall e. Eff (chrome :: Chrome | e) Unit -> Eff (chrome :: Chrome | e) Unit


## Module Chrome.Window

### Types


    type BoundsSpecification = { maxHeight :: Maybe Number, maxWidth :: Maybe Number, minHeight :: Maybe Number, minWidth :: Maybe Number, height :: Maybe Number, width :: Maybe Number, top :: Maybe Number, left :: Maybe Number }


    type CreateWindowOptions = { focused :: Boolean, alwaysOnTop :: Boolean, resizable :: Boolean, hidden :: Boolean, state :: Maybe String, frame :: Maybe String, outerBounds :: Maybe BoundsSpecification, innerBounds :: Maybe BoundsSpecification, id :: Maybe String }


### Values


    bounds :: BoundsSpecification


    createWindow :: forall e. String -> CreateWindowOptions -> Eff (chrome :: Chrome | e) Unit


    createWindowOptions :: CreateWindowOptions
