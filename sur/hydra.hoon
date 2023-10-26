|%
+$  sketch
  [name=@t code=@t]
+$  action
  $%
  [%new-sketch =sketch]
  [%scry-pals ~]
  [%get-sketch =ship] 
  [%to-public =@t]
  ==
+$  update  
  $%                  
  ::[%playing =sketch]
  [%playing (list sketch)]
  [%store sketches=(list @t)]
  ==
+$  tag
  $?  
  %public
  %wip  ::work in progress
  ==
--