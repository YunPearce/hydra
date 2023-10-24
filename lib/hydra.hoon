/-  *hydra
|%
++  dejs
  =,  dejs:format
  |%
    ::
    ++  decode 
    |=  =json
    ^-  action
    (de-action json)
    ++  de-action
    %-  of 
    :~  [%new-sketch to-sketch]
        [%scry-pals ul]
        [%get-sketch to-ship]
    ==
    ++  to-ship
    %-  ot
    :~  :-  %ship
    (se %p)
    ==
    ++  to-sketch
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
  :~  :-  'playing'  s+name.sketch.update
      :-  'code'     s+code.sketch.update
  ==
  %store
  %-  frond
  :-  'sketches'
  :-  %a  
  (turn sketches.update |=(a=@t s+a))
  ==
  --
--