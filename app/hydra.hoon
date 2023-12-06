/-  *hydra
/+  default-agent, dbug, *hydra, server, schooner, view
/*  hydraui         %html  /hydra/index/html  
/*  hydrajs         %js    /hydra/bundle/js   
/*  cssfontawesome  %css   /hydra/css/fontawesome/css  
/*  csscodemirror   %css   /hydra/css/codemirror/css  
/*  csstne          %css   /hydra/css/tomorrow-night-eighties/css
/*  cssshowhint     %css   /hydra/css/show-hint/css  
/*  cssstyle        %css   /hydra/css/style/css  
/*  cssmodal        %css   /hydra/css/modal/css  
/*  solidttf        %ttf   /hydra/webfonts/fa-solid-900/ttf 
/*  solidsvg        %svg   /hydra/webfonts/fa-solid-900/svg
|%
+$  versioned-state 
  $%  state-0
  ==
+$  state-0  $:  %0 
                    host=@p
                    playing=@t
                    store=(map @t [@t tag])
                    dj-pals=(map @p (list sketch))
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
  :: 
++  on-poke  
|=  [=mark =vase]
^-  (quip card _this)
|^
?+  mark  (on-poke:def mark vase)
  %hydra-action
  =/  action=action   !<(action vase)
  ?-  -.action
  ::
  %new-sketch
  ?:  =(name.sketch.action 'sketch_id')
    `this
  =.  store  (~(put by store) name.sketch.action [code.sketch.action %wip])
  =.  playing  name.sketch.action
  `this
  ::
  %scry-pals
  =/  our  (scot %p our.bowl)
  =/  pals  .^((set ship) %gx /[our]/pals/(scot %da now.bowl)/mutuals/noun)
  ::  remove old-pals(pals from map) from pals 
  =.  pals  `(set @p)`(~(dif in pals) ~(key by dj-pals))
  ::
  =/  pal-cards  %+  turn  ~(tap in pals) 
  |=(pal=@p [%pass /poke/pal/(scot %p pal)/(scot %da now.bowl) %agent [pal %hydra] %poke %hydra-action !>([%get-sketch our.bowl])])
  :_  this
  pal-cards
  ::
  %get-sketch
  =/  dj-pal  (~(get by dj-pals) +.action)
  ?~  dj-pal  
  :_  this
  ::subscribe here to ship.action
  :~  [%pass /subscribtion/to/(scot %p +.action) %agent [+.action %hydra] %watch /updates]
  ==
  `this  
  ::
  %to-public
  =/  [code=@t =tag]  (~(got by store) +.action)
  =.  store  (~(put by store) +.action [code %public])
  =/  public=(list sketch)  (public-sketches store)
  :_  this
  :~  [%give %fact ~[/updates] %hydra-update !>(`update`[%playing public])]
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
    =/  =action  (decode:dejs (need json))
      (on-poke [%hydra-action !>(action)])
    ::
    ::
      %'GET'
    ?+  site  [(send dump) this]
    ::
    [%apps %hydra ~]
      ?:  |(=(~ playing) =('sketch_id' playing))
      :_  this 
      %-  send 
        [302 ~ [%redirect './hydra/editor/']]
    ::
      =/  sketch  (trip -:(need (~(get by store) playing)))
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
      [200 ~ [%text-javascript hydrajs]]
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
      %+  welp
      ::adedd poke to get new pals on load of page
      [%pass /self %agent [our.bowl %hydra] %poke %hydra-action !>([%scry-pals ~])]~
      %-  send 
      [200 ~ [%manx ~(home view state)]]
    ::
    [%apps %hydra %library * ~]
    =/  sketch=@t  (snag 3 `(list @t)`site)
    :_  this
      %+  welp
      [%pass /self %agent [our.bowl %hydra] %poke %hydra-action !>([%to-public sketch])]~
      %-  send 
      [200 ~ [%manx ~(each-on-change view state)]]
    ==
  ==
--
++  on-peek   on-peek:def
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
    =/  sketches=(list sketch)  (public-sketches store)
    ?~  sketches
      :_  this
      :~  [%give %fact ~ %hydra-update !>(`update`[%playing ~])]
      ==
    :_  this
    :~  [%give %fact ~ %hydra-update !>(`update`[%playing sketches])]
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
    `this
  `this
  ::
  [%poke %pal * * ~]
  ?.  ?=(%poke-ack -.sign)
    (on-agent:def wire sign)
  ?~  p.sign
    ::~&  ['poke-pal @p' +.+.wire]
    ::here if responde adding to pals 
    =/  path=[@t @t pal=@t @t ~]  wire
    =/  =ship  `ship`(slav %p pal.path)
    :_  this
    :~  [%pass /subscribtion/to/(scot %p ship) %agent [ship %hydra] %watch /updates]
    ==
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
      =/  update=update  !<(update q.cage.sign)  ::[%playing name=@t code=@t]
      ~&  ['update' update]
      ?+  -.update     (on-agent:def wire sign)
        %playing
        =.  dj-pals  (~(put by dj-pals) ship +.update)
        `this
      ==
    ==
  ==
==
++  on-arvo 
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
    [200 ~ [%font-ttf q.+.solidttf]]
  ==
++  public-sketches 
|=  =(map @t [@t tag])
^-  (list sketch)
=/  public=(list [@t [@t tag]])
  %-  homo
  %+  skim  ~(tap by store)
    |=  a=[name=@t val=[=@t =tag]]
    =(tag.val.a %public)
%+  turn  public
|=  [name=@t val=[code=@t =tag]]
[name code.val]
:: ++  patp-from-wire 
:: |=  =wire
:: ^-  ship
:: =/  path=[@t @t pal=@t ~]  wire
:: `ship`(slav %p pal.path)
--