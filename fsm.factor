! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors constructors kernel sequences sets
words.symbol models ;
IN: fsm


SYMBOL: undefined-state

TUPLE: fsm < model
  { states set }
  { transitions set }
  { current-state symbol initial: undefined-state } ;

TUPLE: transition
  { from-states sequence }
  { to-state symbol initial: undefined-state }
  { action } ;

GENERIC: next-states ( obj -- states )
GENERIC: next-actions ( obj -- actions )
GENERIC# transition 1 ( obj state -- )

ERROR: bad-transition ;

: transitions-for ( obj state -- transition-map )
    [ transitions>> ] dip
    [ swap from-states>> in? ] curry
    filter ;

: current-transitions ( obj -- edges )
    dup current-state>> transitions-for ;

M: fsm next-states
    current-transitions [ to-state>> ] map ;


M: fsm next-actions ( obj -- actions )
    current-transitions [ action>> ] map ;


: in-next-states? ( obj state -- ? )
    [ next-states ] dip swap in? ;

M: fsm transition ( obj state -- )
    2dup
    in-next-states?
    [ bad-transition ] unless
    [ >>current-state ] keep name>> swap set-model ;

: <fsm> ( states transitions current-state -- fsm )
    dup name>> fsm new-model
    [ current-state<< ] keep
    [ transitions<< ] keep
    [ states<< ] keep ;
