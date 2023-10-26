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
        [%to-public so]
        ::[%to-public to-sketch]
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
  :-  %a
  %+  turn  +.update
    |=  sketch=[name=@t code=@t]
    %-  pairs 
    :~  :-  'playing'  s+name.sketch
        :-  'code'     s+code.sketch
    ==
  %store
  %-  frond
  :-  'sketches'
  :-  %a  
  (turn sketches.update |=(a=@t s+a))
  ==
  --
--