|%
+$  action
  $%
  [%new-sketch id=@t hash=@t]
  :: [%to-sketch id=@t code=@t]
  ==
::
+$  update
  $%
  [%playing id=@t]
  ==
::
++  dejs
  =,  dejs:format
  |%
    ::
    ++  decode 
    |=  =json
    ^-  action
    (action json)
    ++  action
    %-  of 
    :~  [%new-sketch store-pair]
        :: [%to-sketch hash]
    ==
    :: ++  hash
    :: %-  ot 
    :: :~  [%parent so]
    ::     [%code so]
    :: ==
    ++  store-pair
    %-  ot 
    :~  [%id so]
        [%code so]
    ==
    --
::
++  enjs
  =,  enjs:format
  |%
  ++  update-to-json 
  |=  =update
  ^-  json
  ::|^
  ?-  -.update 
  %playing
  %-  pairs 
  :~  :-  'playing'  s+id.update
  ==
  ==
  --
--