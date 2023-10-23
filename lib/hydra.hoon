|%
+$  sketch
  [name=@t code=@t]
::
+$  action
  $%
  [%new-sketch sketch]
  [%scry-pals ~]
  [%get-sketch ship]   ::@t (unit @t)]
  :: [%to-sketch id=@t code=@t]
  ==
::
+$  update
  $%                  
  [%playing sketch]
  [%store sketches=(list @t)]
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
    :~  [%new-sketch sketch]
        :: [%to-sketch hash]
    ==
    :: ++  hash
    :: %-  ot 
    :: :~  [%parent so]
    ::     [%code so]
    :: ==
    ++  sketch
    %-  ot 
    :~  [%name so]
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
  :~  :-  'playing'  s+name.update
      :-  'code'     s+code.update
  ==
  %store
  %-  frond
  :-  'sketches'
  :-  %a  
  (turn sketches.update |=(a=@t s+a))
  ==
  --
--