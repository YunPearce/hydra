/-  hydra
/+  default-agent, dbug, *hydra, server, schooner, view
/*  hydraui         %html  /app/hydra/index/html
/*  hydrajs         %js    /app/hydra/bundle/js
/*  cssfontawesome  %css   /app/hydra/css/fontawesome/css
/*  csscodemirror   %css   /app/hydra/css/codemirror/css
/*  csstne          %css   /app/hydra/css/tomorrow-night-eighties/css
/*  cssshowhint     %css   /app/hydra/css/show-hint/css
/*  cssstyle        %css   /app/hydra/css/style/css
/*  cssmodal        %css   /app/hydra/css/modal/css
/*  solidttf        %ttf   /app/hydra/webfonts/fa-solid-900/ttf
/*  solidsvg        %svg   /app/hydra/webfonts/fa-solid-900/svg 
|%
+$  versioned-state 
  $%  state-0
  ==
+$  state-0  $:  %0 
                    host=@p
                    playing=@t         ::id, updated by saving sketch or by sharing code
                    store=(map @t @t)  ::store=(map id hash/code)
                    dj-pals=(map @p sketch:hydra)
                    ==
+$  card  card:agent:gall
--  
!:
=|  state-0
=*  state  -
%-  agent:dbug
^-  agent:gall
=<
    |_  =bowl:gall
    +*  this      .
        def   ~(. (default-agent this %.n) bowl)
        hc       ~(. +> bowl)
        ::
++  on-init  
  ^-  (quip card _this)
  ::`this
  ~&  >  "hydra initialized successfully."
  =.  host  our.bowl
  :_  this
  :~  [%pass /eyre %arvo %e %connect [~ /apps/hydra] %hydra]
      [%pass /self %agent [our.bowl %hydra] %poke %hydra-action !>([%scry-pals ~])]
  ==
::
++  on-save  
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
  ::
  :: add sketch to store
  :: sketch to play(?)
  :: 
++  on-poke  
|=  [=mark =vase]
^-  (quip card _this)
|^
~&  mark
?+  mark  (on-poke:def mark vase)
  %hydra-action
  =/  action=action:hydra   !<(action:hydra vase)
  ?-  -.action
  ::[%new-sketch id=@t hash=@t]
  %new-sketch
  =.  store  (~(put by store) name.sketch.action code.sketch.action)
  ?:  =(name.sketch.action 'sketch_id')
    `this
  =.  playing  name.sketch.action
  `this
  ::
  ::
  %scry-pals
  =/  our  (scot %p our.bowl)
  =/  pals  .^((set ship) %gx /[our]/pals/(scot %da now.bowl)/mutuals/noun)
  ~&  ['pals' pals]
  =/  pal-cards  %+  turn  ~(tap in pals) 
  |=(pal=@p [%pass /poke/pal/(scot %p pal) %agent [pal %hydra] %poke %hydra-action !>([%get-sketch our.bowl])])
  ~&  ['pal cards' pal-cards]
  :_  this
  pal-cards
  ::
  %get-sketch 
  =/  dj-pal  (~(get by dj-pals) +.action)
  ~&  ['dj-pal' dj-pal]
  ?~  dj-pal  `this  
  :_  this
  ::~
  ::subscribe here to ship.action
  :~  [%pass /subscribtion/to/(scot %p +.action) %agent [+.action %hydra] %watch /updates]
  ==
  ==
  ::
  %handle-http-request
  (handle-http !<([@ta =inbound-request:eyre] vase))
==
  ++  handle-http
  |=  [eyre-id=@ta =inbound-request:eyre]
  ^-  (quip card _this)
  =/  ,request-line:server
    (parse-request-line:server url.request.inbound-request)
  =+  send=(cury response:schooner eyre-id)
  ?.  authenticated.inbound-request
    :_  this
    %-  send
    [302 ~ [%login-redirect './apps/hydra/editor/']]
  ?+    method.request.inbound-request
    [(send [405 ~ [%stock ~]]) this]
    ::
      %'POST'
    ?~  body.request.inbound-request  [(send [405 ~ [%stock ~]]) this]
    =/  json  (de:json:html q.u.body.request.inbound-request)
    =/  action  (decode:dejs +.json)
    (on-poke [%hydra-action !>(action)])
    ::instead of on-peek 
    ::`this
      %'GET'
    ~&  site
    ?+  site  [(send dump) this]
    ::
    [%apps %hydra ~]
      ?:  |(=(~ playing) =('sketch_id' playing))
      :_  this 
      %-  send 
    [302 ~ [%redirect './hydra/editor/']]
      =/  sketch  (trip (need (~(get by store) playing)))
      =/  path    (crip (weld "./hydra/editor/?sketch_id=" sketch))
        :_  this
        %-  send 
        [302 ~ [%redirect path]]
    ::
    ::host pages
    ::
    [%apps %hydra %editor * ~]
      :_  this
      %-  send 
      [200 ~ [%html hydraui]]
    ::
    [%apps %hydra %editor %bundle %js ~]
      :_  this 
      %-  send 
      [200 ~ [%plain (trip hydrajs)]]
    ::
    [%apps %hydra %editor %webfonts %ttf * ~]
      :_  this 
      %-  send
      (ttffronts site)
    ::
    [%apps %hydra %editor %css * ~]
      :_  this 
      %-  send
      (hydra-css site)
    ::
    [%apps %hydra %editor %webfonts * ~]
      :_  this 
      %-  send
      (webfronts site)
    ::
    ::store frontend
    ::
    [%apps %hydra %library ~]
      :_  this
      %-  send 
      [200 ~ [%manx ~(home view state)]]
    ::
    ::  list of sketches
    ::
    :: [%apps %hydra %my-lib ~]
    ::   =/  sketches  ~(tap in ~(key by store))
    ::   :_  this
    ::   %-  send
    ::   [200 ~ [%json (update-to-json:enjs [%store sketches])]]
    ==
  ==
--
++  on-peek   on-peek:def
:: |=  =path
:: ^-  (unit (unit cage))
:: ?+  path  (on-peek:def path)
:: ::current id(?) playing 
::   [%x %playing ~]
::   :^  ~  ~  %hydra-update
::   !>  ^-  update
::   [%playing =playing =(need (~(get by store) playing))]
:: ==
::
++  on-watch  
|=  =path
^-  (quip card _this)
?+    path  (on-watch:def path)
    [%http-response *]
  ?:  =(our src):bowl
    `this         
  (on-watch:def path)
  ::
    [%updates ~] 
    ~&  'comet subscriber here to watch'
    =/  code  (need (~(get by store) playing))
    :_  this
    :~  [%give %fact ~ %hydra-update !>(`update:hydra`[%playing [playing code]])]
==
==
::
::
++  on-agent  
|=  [=wire =sign:agent:gall]
^-  (quip card _this)
?+    wire  (on-agent:def wire sign)
  [%hydra ~]
  ?+    -.sign  (on-agent:def wire sign)
    %watch-ack
  ?~  p.sign
    ((slog '%hydra: Subscribe succeeded!' ~) `this)
  ((slog '%hydra: Subscribe failed!' ~) `this)
  ==
  ::
  [%self ~]
  ?.  ?=(%poke-ack -.sign)
  (on-agent:def wire sign)
  ?~  p.sign
    %-  (slog 'poke self success' ~)
    `this
  %-  (slog 'poke self fail' ~)
  `this
  ::
  [%poke %pal * ~]
  ?.  ?=(%poke-ack -.sign)
    (on-agent:def wire sign)
  ?~  p.sign
    ~&  ['poke-pal @p' +.+.wire]
    ::here if responde adding to pals 
    =/  path=[@t @t pal=@t ~]  wire
    =/  =ship  `ship`(slav %p pal.path)
    :_  this
    :~  [%pass /subscribtion/to/(scot %p ship) %agent [ship %hydra] %watch /updates]
    ==
  ::%-  (slog 'poke failed!' ~)
  `this
  ::
  [%subscribtion %to * ~]
    ?+  -.sign  (on-agent:def wire sign)
      %watch-ack
    ?~  p.sign
      ((slog 'Subscribe succeeded!' ~) `this)
    ((slog 'Subscribe failed!' ~) `this)
  ::
      %kick 
      %-  (slog 'Got kick' ~)
      `this 
    ::
      %fact
    ?+    p.cage.sign  (on-agent:def wire sign)
        %hydra-update
        ~&  'hydra update'
      =/  path=[@t @t pal=@t ~]  wire
      =/  =ship        `ship`(slav %p pal.path)  
      =/  update=update:hydra  !<(update:hydra q.cage.sign)  ::[%playing name=@t code=@t]
      ~&  ['update' update]
      ?+  -.update     (on-agent:def wire sign)
        %playing
        =.  dj-pals  (~(put by dj-pals) ship +.update)
        `this
      ==
    ==
  ==
==
++  on-arvo   ::on-arvo:def
|=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%eyre %bound *] sign-arvo)
    (on-arvo:def [wire sign-arvo])
  ?:  accepted.sign-arvo
    %-  (slog leaf+"/apps/hydra bound successfully!" ~)
    `this
  %-  (slog leaf+"Binding /apps/hydra failed!" ~)
 `this
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
::
::|%
::++  hc
::
|_  bowl=bowl:gall
::
++  dump  [404 ~ [%plain "404 - Not Found"]]
++  hydra-css
|=  site=(list @t)
?+  (rear site)  dump
    %fontawesome
    [200 ~ [%text-css cssfontawesome]]
    ::
    %codemirror 
    [200 ~ [%text-css csscodemirror]]
    ::
    %tomorrow-night-eighties 
    [200 ~ [%text-css csstne]]
    ::
    %show-hint 
    [200 ~ [%text-css cssshowhint]]
    ::
    %style
    [200 ~ [%text-css cssstyle]]
    ::
    %modal
    [200 ~ [%text-css cssmodal]]
  ==
  ::
++  webfronts
|=  site=(list @t)
?+  (rear site)  dump
    %fa-solid-900
    [200 ~ [%image-svg solidsvg]]
  ==
++  ttffronts
|=  site=(list @t)
?+  (rear site)  dump
    %fa-solid-900
    [200 ~ [%font-ttf q.solidttf]]
  ==
:: ++  patp-from-wire 
:: |=  =wire
:: ^-  ship
:: =/  path=[@t @t pal=@t ~]  wire
:: `ship`(slav %p pal.path)
--