function toggle_hide_show_with_smart_loading( id_to_show, ids_to_hide ) {
	id_to_show = $(id_to_show);
	if( id_to_show.visible() ) {
		new Effect.BlindUp( id_to_show, { duration: 0.3 } );
		return false;
	} else if( id_to_show.innerHTML != '' ) {
		ids_to_hide.each( 
			function( id_to_hide ) { 
				new Effect.BlindUp( id_to_hide, { duration: 0.3 } ); 
			}
		);
		
		setTimeout( 
			function() { 
				var window_top =  window.pageYOffset
					|| document.documentElement.scrollTop
					|| document.body.scrollTop
					|| 0;
				var window_height = window.innerHeight
					|| document.body.innerHeight
					|| 0;

				var element_top = Position.cumulativeOffset( id_to_show )[1];
				var element_height = id_to_show.getHeight();

				if( element_top + element_height > window_top + window_height ) {
					window.scrollBy( 0, ( element_top + element_height ) - ( window_top + window_height ) );
				}
			}, 500 ); 

		new Effect.BlindDown( id_to_show, { duration: 0.3 } );
		if( arguments[2] ) {
			Selector.findChildElements( id_to_show, $A( [ "form" ] ) ).each( 
				function( form ) { 
					setTimeout( 
						function() { 
							form.focusFirstElement(); 
						}, 500 ); 
					}
			);
		}
		return false;
	}
	return true;
}