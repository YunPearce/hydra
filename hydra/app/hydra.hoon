/+  default-agent, dbug, *hydra, server, schooner
/*  hydraui         %html  /app/hydra/index/html
/*  hydrajs         %js    /app/hydra/bundle/js
/*  cssfontawesome  %css   /app/hydra/css/fontawesome/css
/*  csscodemirror   %css   /app/hydra/css/codemirror/css
/*  csstne          %css   /app/hydra/css/tomorrow-night-eighties/css
/*  cssshowhint     %css   /app/hydra/css/show-hint/css
/*  cssstyle        %css   /app/hydra/css/style/css
/*  cssmodal        %css   /app/hydra/css/modal/css
/*  cssnormalize    %css   /app/hydra/css/normalize/css
/*  cssskeleton     %css   /app/hydra/css/skeleton/css
/*  brandssvg       %svg   /app/hydra/webfonts/fa-brands-400/svg
/*  brandsttf       %ttf   /app/hydra/webfonts/fa-brands-400/ttf
/*  regsvg          %svg   /app/hydra/webfonts/fa-regular-400/svg
/*  regttf          %ttf   /app/hydra/webfonts/fa-regular-400/ttf
/*  solidttf        %noun   /app/hydra/webfonts/fa-solid-900/ttf
/*  solidsvg        %svg   /app/hydra/webfonts/fa-solid-900/svg
/*  solidwoff     %noun   /app/hydra/webfonts/fa-solid-900/woff2
|%
+$  versioned-state 
  $%  state-0
  ==
+$  state-0  $:  %0 
                    host=@p
                    playing=@t         ::id, updated by saving sketch or by sharing code
                    store=(map @t @t)  ::store=(map id hash/code)
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
  :_  this
  :~  [%pass /eyre %arvo %e %connect [~ /apps/hydra] %hydra]
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
  =/  action=action   !<(action vase)
  ?-  -.action
  ::[%new-sketch id=@t hash=@t]
  %new-sketch
  =.  store  (~(put by store) id.action hash.action)
  ?:  =(id.action 'sketch_id')
    `this
  =.  playing  id.action
  `this
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
  ~&  site
  ?.  authenticated.inbound-request
    :_  this
    %-  send
    [302 ~ [%login-redirect './apps/hydra']]
  ?+    method.request.inbound-request
    [(send [405 ~ [%stock ~]]) this]
    ::
      %'POST'
    ?~  body.request.inbound-request  [(send [405 ~ [%stock ~]]) this]
    =/  json  (de:json:html q.u.body.request.inbound-request)
    ~&  json
    =/  act=action  (decode:dejs +.json)
    ~&  act
    (on-poke [%hydra-action !>(act)])
    ::instead of on-peek 
    ::`this
    %'GET'
    ~&  site
    ?+  site  
              :_  this
              %-  send
              dump
    [%apps %hydra ~]
    ~&  playing
    ::FOR NOW
      ?:  &(=(~ playing) =('sketch_id' playing))
      :_  this 
      %-  send 
    [302 ~ [%redirect './hydra/']]
      =/  sketch  (trip (need (~(get by store) playing)))
      =/  path    (crip (weld "./hydra/?sketch_id=" sketch))
        :_  this
        %-  send 
        [302 ~ [%redirect path]]
    ::
    ::host pages
    ::
    [%apps %hydra * ~]
      :_  this
      %-  send 
      [200 ~ [%html hydraui]]
    ::
    [%apps %hydra %bundle %js ~]
    :_  this 
    %-  send 
    [200 ~ [%plain (trip hydrajs)]]
    ::
    [%apps %hydra %css * ~]
    :_  this 
    %-  send
    (hydra-css site)
    ::
    [%apps %hydra %webfonts * ~]
    ~&  +15.site
    :_  this 
    %-  send
    (webfronts +15.site)
    [%apps %hydra %webfonts * * ~]
    :_  this 
    %-  send
    (ttffronts +15.site)
    ::
    [%apps %hydra %whoami ~]
    :_  this
    %-  send
    [200 ~ [%plain (scow %p our.bowl)]]
    ::
    [%apps %hydra %playing ~]
      :_  this
      %-  send
      [200 ~ [%json (update-to-json:enjs [%playing id=playing])]]
    ==
  ==
--
++  on-peek   
|=  =path
^-  (unit (unit cage))
?+  path  (on-peek:def path)
::current id(?) playing 
  [%x %playing ~]
  :^  ~  ~  %hydra-update
  !>  ^-  update
  [%playing id=playing]
==
::
++  on-watch  
|=  =path
^-  (quip card _this)
?+    path  (on-watch:def path)
    [%http-response *]
  ?:  =(our src):bowl
    `this
  (on-watch:def path)
==
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
  [%thread ~]
  ?+    -.sign  (on-agent:def wire sign)
    %poke-ack
  ?~  p.sign  
    %-  (slog leaf+"Thread started successfully" ~)
    `this
  %-  (slog leaf+"Thread failed to start" u.p.sign)
  `this
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
  ::
  ++  give-http
    |=  [eyre-id=@ta hed=response-header:http dat=(unit octs)]
    ^-  (list card)
    ~&  hed
    ~&  'give http'
    :~  [%give %fact ~[/http-response/[eyre-id]] %http-response-header !>(hed)]
        [%give %fact ~[/http-response/[eyre-id]] %http-response-data !>(dat)]
        [%give %kick ~[/http-response/[eyre-id]] ~]
    ==
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
    ::
    %normalize
    [200 ~ [%text-css cssnormalize]]
    ::
    %skeleton 
    [200 ~ [%text-css cssskeleton]]
  ==
  ::
++  webfronts
|=  site=(list @t)
?+  site  dump
    [%fa-solid-900 ~]
    [200 ~ [%image-svg solidsvg]]
    ::
    [%fa-brands-400 ~]
    [200 ~ [%image-svg brandssvg]]
    ::
    [%fa-regular-400 ~]
    [200 ~ [%image-svg regsvg]]
  ==
++  ttffronts
|=  site=(list @t)
?+  site  dump
    [%fa-solid-900 %ttf ~]
    [200 ~ [%font-ttf q.solidttf]]
    ::
    [%fa-solid-900 %woff2 ~]
    [200 ~ [%font-woff2 q.solidwoff]]
    ::
    [%fa-brands-900 %ttf ~]
    [200 ~ [%font-ttf q.brandsttf]]
    ::
    [%fa-regular-900 %ttf ~]
    [200 ~ [%font-ttf q.regttf]]
  ==
--