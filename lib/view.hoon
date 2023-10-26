/+  *hydra
|_  [%0 * * store=(map @t [@t tag]) dj-pals=(map @p (list sketch))]
::
++  page
  |=  kid=manx
  ^-  manx
  ;html
    ;head
      ;title: Hydra
      ;meta(charset "utf-8");
      ;script
        =crossorigin  "anonymous"
        =integrity    "sha384-aOxz9UdWG0yBiyrTwPeMibmaoq07/d3a96GCbb9x60f3mOt5zwkjdbcHFnKH8qls"
        =src          "https://unpkg.com/htmx.org@1.9.0";
      ;script
        =crossorigin  "anonymous"
        =integrity    "sha384-nRnAvEUI7N/XvvowiMiq7oEI04gOXMCqD3Bidvedw+YNbj7zTQACPlRI3Jt3vYM4"
        =src          "https://unpkg.com/htmx.org@1.9.0/dist/ext/json-enc.js";
      ;link
        =rel          "stylesheet"
        =crossorigin  "anonymous"
        =integrity    "sha384-Kh+o8x578oGal2nue9zyjl2GP9iGiZ535uZ3CxB3mZf3DcIjovs4J1joi2p+uK18"
        =href         "https://unpkg.com/@fontsource/lora@5.0.8/index.css";
      ;style: {style}
    ==
    ;body(hx-ext "json-enc,include-vals")
      ;+  kid
    ==
  ==
::
++  path 
"../hydra/editor/?sketch_id="
::
++  home
  %-  page
  ;div
  ;h1: Sketches:
  ;div.sketches
    ;*  %+  turn
      ~(tap by store)
    |=  [name=@t sketch=[hash=@t tag=tag]]
    ^-  manx
      ?:  =(tag.sketch %public)
      ^-  manx
      ::;div.each(sketch (trip name))
        ;a(href (weld path (trip hash.sketch))): {(trip name)}
        ::;h2: album {(scow %tas tag)}
      ;div.each(sketch (trip name))
        ;a(href (weld path (trip hash.sketch))): {(trip name)}
        ::;h2: album {(scow %tas tag)}
        ;form
        ;input(type "hidden", name "to-public", value (trip name));
        ;button(hx-post ".", hx-target "body"): share with pals
        ==
      ==
  ==
  ;h1: Pals new sketches:
    ;*  %+  turn
      ~(tap by dj-pals)
    |=  [pal=@p sketches=(list sketch)]
    ;div.each(pal (trip pal))
      ;h3: {(scow %p pal)}v
      ;*  %+  turn  sketches
      |=  sketch=[name=@t code=@t]
      ^-  manx
    ::FIX if null no song or pal show
      ;div
        ;a(href (weld path (trip code.sketch))): {(trip name.sketch)}
      ==
  ==
  ==
++  style
  ^~
  %-  trip
  '''
  :root {
  --measure: 70ch;
  }
  '''
--
